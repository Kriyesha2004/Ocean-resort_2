const { useState, useEffect, useRef } = React;

const ReportsDashboard = () => {
    const [filters, setFilters] = useState({
        year: new Date().getFullYear(),
        month: new Date().getMonth() + 1, // 1-12
        chartView: 'monthly' // monthly | yearly
    });
    const [stats, setStats] = useState(null);
    const [bookings, setBookings] = useState([]);
    const [chartData, setChartData] = useState(null);
    const chartRef = useRef(null);
    const chartInstance = useRef(null);

    // Fetch Stats
    useEffect(() => {
        fetch('api/reports?action=stats')
            .then(res => res.json())
            .then(data => setStats(data))
            .catch(err => console.error("Error fetching stats:", err));
    }, []);

    // Fetch Bookings
    useEffect(() => {
        fetch('api/reports?action=bookings&year=' + filters.year + '&month=' + filters.month)
            .then(res => res.json())
            .then(data => setBookings(data))
            .catch(err => console.error("Error fetching bookings:", err));
    }, [filters.year, filters.month]);

    // Fetch Chart Data
    useEffect(() => {
        fetch('api/reports?action=chart&type=' + filters.chartView + '&year=' + filters.year)
            .then(res => res.json())
            .then(data => {
                setChartData(data);
                renderChart(data);
            })
            .catch(err => console.error("Error fetching chart data:", err));
    }, [filters.chartView, filters.year]);

    const renderChart = (data) => {
        if (chartInstance.current) {
            chartInstance.current.destroy();
        }
        const ctx = chartRef.current.getContext('2d');
        chartInstance.current = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.labels,
                datasets: [{
                    label: filters.chartView === 'monthly' ? 'Revenue (' + filters.year + ')' : 'Yearly Revenue',
                    data: data.data,
                    backgroundColor: 'rgba(54, 162, 235, 0.5)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'top' },
                    title: { display: true, text: 'Revenue Trends' }
                }
            }
        });
    };

    const exportToExcel = () => {
        const ws = XLSX.utils.json_to_sheet(bookings);
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Bookings");
        XLSX.writeFile(wb, 'Reports_' + filters.year + '_' + filters.month + '.xlsx');
    };

    return (
        <div>
            <div className="row mb-4">
                <div className="col-md-12">
                    <h1 className="display-6 text-primary">
                        <i className="bi bi-file-earmark-pdf"></i> Reports & Analytics
                    </h1>
                </div>
            </div>

            {/* Filters */}
            <div className="card shadow-sm mb-4">
                <div className="card-body">
                    <div className="row g-3 align-items-end">
                        <div className="col-md-3">
                            <label className="form-label">Year</label>
                            <select className="form-select" value={filters.year}
                                onChange={e => setFilters({ ...filters, year: e.target.value })}>
                                <option value="2024">2024</option>
                                <option value="2025">2025</option>
                                <option value="2026">2026</option>
                            </select>
                        </div>
                        <div className="col-md-3">
                            <label className="form-label">Month</label>
                            <select className="form-select" value={filters.month}
                                onChange={e => setFilters({ ...filters, month: e.target.value })}>
                                <option value="all">All Months</option>
                                {[...Array(12).keys()].map(i => (
                                    <option key={i + 1} value={i + 1}>{new Date(0, i).toLocaleString('default', { month: 'long' })}</option>
                                ))}
                            </select>
                        </div>
                        <div className="col-md-3">
                            <label className="form-label">Chart View</label>
                            <div className="btn-group w-100" role="group">
                                <button type="button"
                                    className={'btn ' + (filters.chartView === 'monthly' ? 'btn-primary' : 'btn-outline-primary')}
                                    onClick={() => setFilters({ ...filters, chartView: 'monthly' })}>
                                    Monthly
                                </button>
                                <button type="button"
                                    className={'btn ' + (filters.chartView === 'yearly' ? 'btn-primary' : 'btn-outline-primary')}
                                    onClick={() => setFilters({ ...filters, chartView: 'yearly' })}>
                                    Yearly
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Stats Cards */}
            {stats && (
                <div className="row g-4 mb-4">
                    <div className="col-md-4">
                        <div className="card border-0 shadow-sm text-center">
                            <div className="card-body">
                                <h6 className="text-muted">Total Bookings</h6>
                                <h3 className="text-primary">{stats.totalBookings}</h3>
                            </div>
                        </div>
                    </div>
                    <div className="col-md-4">
                        <div className="card border-0 shadow-sm text-center">
                            <div className="card-body">
                                <h6 className="text-muted">Total Revenue</h6>
                                <h3 className="text-success">${stats.totalRevenue.toFixed(2)}</h3>
                            </div>
                        </div>
                    </div>
                    <div className="col-md-4">
                        <div className="card border-0 shadow-sm text-center">
                            <div className="card-body">
                                <h6 className="text-muted">Checked-In Guests</h6>
                                <h3 className="text-info">{stats.checkedIn}</h3>
                            </div>
                        </div>
                    </div>
                </div>
            )}

            {/* Chart Section */}
            <div className="card shadow-sm mb-4">
                <div className="card-header bg-white">
                    <h5 className="mb-0">Revenue Overview</h5>
                </div>
                <div className="card-body">
                    <canvas ref={chartRef} style={{ maxHeight: '400px' }}></canvas>
                </div>
            </div>

            {/* Data Table */}
            <div className="card shadow-sm">
                <div className="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 className="mb-0">Booking Details</h5>
                    <button className="btn btn-success btn-sm" onClick={exportToExcel}>
                        <i className="bi bi-file-earmark-excel"></i> Export to Excel
                    </button>
                </div>
                <div className="table-responsive">
                    <table className="table table-hover mb-0">
                        <thead className="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Guest Name</th>
                                <th>Room Type</th>
                                <th>Check In</th>
                                <th>Check Out</th>
                                <th>Status</th>
                                <th className="text-end">Total Bill</th>
                            </tr>
                        </thead>
                        <tbody>
                            {bookings.length > 0 ? (
                                bookings.map(b => (
                                    <tr key={b.id}>
                                        <td>#{b.id}</td>
                                        <td>{b.guestName}</td>
                                        <td>{b.roomType}</td>
                                        <td>{b.checkIn}</td>
                                        <td>{b.checkOut}</td>
                                        <td>
                                            <span className={'badge ' + (
                                                b.status === 'Checked-In' ? 'bg-success' :
                                                    b.status === 'Pending' ? 'bg-warning' : 'bg-secondary'
                                            )}>
                                                {b.status}
                                            </span>
                                        </td>
                                        <td className="text-end">${b.totalBill.toFixed(2)}</td>
                                    </tr>
                                ))
                            ) : (
                                <tr>
                                    <td colSpan="7" className="text-center py-4 text-muted">No bookings found for this period.</td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
};

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<ReportsDashboard />);
