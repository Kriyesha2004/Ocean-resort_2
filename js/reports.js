const { useState, useEffect, useRef, useMemo } = React;

const ReportsDashboard = () => {
    // Server-side Filters (Scope)
    const [sqFilters, setSqFilters] = useState({
        year: new Date().getFullYear(),
        month: 'all', // Default to all months for better overview
        chartView: 'monthly'
    });

    // Client-side Filters (Refinement)
    const [clientFilters, setClientFilters] = useState({
        search: '',
        roomType: 'all',
        status: 'all'
    });

    // Data State
    const [bookings, setBookings] = useState([]);
    const [loading, setLoading] = useState(false);

    // Refs for Charts
    const revenueChartRef = useRef(null);
    const roomTypeChartRef = useRef(null);
    const revenueChartInstance = useRef(null);
    const roomTypeChartInstance = useRef(null);

    // -- 1. Fetch Data --
    useEffect(() => {
        setLoading(true);
        // Fetch bookings for the selected scope
        fetch('api/reports?action=bookings&year=' + sqFilters.year + '&month=' + sqFilters.month)
            .then(res => res.json())
            .then(data => {
                setBookings(data);
                setLoading(false);
            })
            .catch(err => {
                console.error("Error fetching bookings:", err);
                setLoading(false);
            });
    }, [sqFilters.year, sqFilters.month]);

    // -- 2. Client-Side Filtering & Stats Calculation --
    const filteredBookings = useMemo(() => {
        return bookings.filter(b => {
            const matchesSearch = b.guestName.toLowerCase().includes(clientFilters.search.toLowerCase()) ||
                b.id.toString().includes(clientFilters.search);
            const matchesRoom = clientFilters.roomType === 'all' || b.roomType === clientFilters.roomType;
            const matchesStatus = clientFilters.status === 'all' || b.status === clientFilters.status;
            return matchesSearch && matchesRoom && matchesStatus;
        });
    }, [bookings, clientFilters]);

    const dynamicStats = useMemo(() => {
        return filteredBookings.reduce((acc, curr) => {
            acc.count++;
            acc.revenue += curr.totalBill;
            if (curr.status === 'Checked-In') acc.checkedIn++;
            return acc;
        }, { count: 0, revenue: 0, checkedIn: 0 });
    }, [filteredBookings]);

    // -- 3. Chart Rendering --
    useEffect(() => {
        if (!bookings.length) return;

        // A. Revenue Trend Chart (Bar/Line)
        // Aggregating data based on chartView (Monthly vs Yearly is handled by API usually, 
        // but here we can aggregate from the filtered list if 'month' is 'all')

        // Let's create a histogram from filteredBookings for the current view
        const labels = [];
        const dataPoints = [];

        if (sqFilters.month === 'all') {
            // Show monthly trend for the year
            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            const monthData = new Array(12).fill(0);
            filteredBookings.forEach(b => {
                const date = new Date(b.checkIn);
                monthData[date.getMonth()] += b.totalBill;
            });
            labels.push(...months);
            dataPoints.push(...monthData);
        } else {
            // Show daily trend for the month
            filteredBookings.forEach(b => {
                labels.push(b.checkIn); // Simple date label
                dataPoints.push(b.totalBill);
            });
            // Sort by date would be better but keeping it simple for now
        }

        if (revenueChartInstance.current) revenueChartInstance.current.destroy();

        const revCtx = revenueChartRef.current.getContext('2d');
        revenueChartInstance.current = new Chart(revCtx, {
            type: sqFilters.month === 'all' ? 'bar' : 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Revenue',
                    data: dataPoints,
                    backgroundColor: 'rgba(75, 192, 192, 0.5)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1,
                    fill: sqFilters.month !== 'all'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    title: { display: true, text: sqFilters.month === 'all' ? 'Monthly Revenue Trend' : 'Daily Revenue' }
                }
            }
        });

        // B. Revenue by Room Type (Doughnut)
        const roomStats = filteredBookings.reduce((acc, curr) => {
            acc[curr.roomType] = (acc[curr.roomType] || 0) + curr.totalBill;
            return acc;
        }, {});

        if (roomTypeChartInstance.current) roomTypeChartInstance.current.destroy();

        const roomCtx = roomTypeChartRef.current.getContext('2d');
        roomTypeChartInstance.current = new Chart(roomCtx, {
            type: 'doughnut',
            data: {
                labels: Object.keys(roomStats),
                datasets: [{
                    data: Object.values(roomStats),
                    backgroundColor: [
                        '#FF6384',
                        '#36A2EB',
                        '#FFCE56',
                        '#4BC0C0',
                        '#9966FF'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'right' },
                    title: { display: true, text: 'Revenue by Room Type' }
                }
            }
        });

    }, [filteredBookings, sqFilters]); // Re-render charts when filtered data changes

    // -- 4. Excel Export --
    const exportToExcel = () => {
        const ws = XLSX.utils.json_to_sheet(filteredBookings);
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Filtered_Bookings");
        XLSX.writeFile(wb, 'Report_Export.xlsx');
    };

    return (
        <div>
            <div className="row mb-4">
                <div className="col-md-12">
                    <h1 className="display-6 text-primary">
                        <i className="bi bi-file-earmark-pdf"></i> Dashboard Reports
                    </h1>
                </div>
            </div>

            {/* Scope Filters */}
            <div className="card shadow-sm mb-4">
                <div className="card-header bg-light">
                    <h5 className="mb-0 fs-6 text-muted text-uppercase fw-bold">1. Select Data Scope</h5>
                </div>
                <div className="card-body">
                    <div className="row g-3">
                        <div className="col-md-4">
                            <label className="form-label">Year</label>
                            <select className="form-select" value={sqFilters.year}
                                onChange={e => setSqFilters({ ...sqFilters, year: e.target.value })}>
                                <option value="2024">2024</option>
                                <option value="2025">2025</option>
                                <option value="2026">2026</option>
                            </select>
                        </div>
                        <div className="col-md-4">
                            <label className="form-label">Month</label>
                            <select className="form-select" value={sqFilters.month}
                                onChange={e => setSqFilters({ ...sqFilters, month: e.target.value })}>
                                <option value="all">Entire Year</option>
                                {[...Array(12).keys()].map(i => (
                                    <option key={i + 1} value={i + 1}>{new Date(0, i).toLocaleString('default', { month: 'long' })}</option>
                                ))}
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            {/* Stats Cards (Dynamic) */}
            <div className="row g-4 mb-4">
                <div className="col-md-4">
                    <div className="card border-0 shadow-sm text-center border-start border-4 border-primary">
                        <div className="card-body">
                            <h6 className="text-muted text-uppercase small">Total Bookings</h6>
                            <h2 className="text-primary mb-0">{dynamicStats.count}</h2>
                        </div>
                    </div>
                </div>
                <div className="col-md-4">
                    <div className="card border-0 shadow-sm text-center border-start border-4 border-success">
                        <div className="card-body">
                            <h6 className="text-muted text-uppercase small">Total Revenue</h6>
                            <h2 className="text-success mb-0">${dynamicStats.revenue.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</h2>
                        </div>
                    </div>
                </div>
                <div className="col-md-4">
                    <div className="card border-0 shadow-sm text-center border-start border-4 border-info">
                        <div className="card-body">
                            <h6 className="text-muted text-uppercase small">Checked-In</h6>
                            <h2 className="text-info mb-0">{dynamicStats.checkedIn}</h2>
                        </div>
                    </div>
                </div>
            </div>

            {/* Charts Row */}
            <div className="row g-4 mb-4">
                <div className="col-lg-8">
                    <div className="card shadow-sm h-100">
                        <div className="card-body">
                            <div style={{ height: '300px' }}>
                                <canvas ref={revenueChartRef}></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="col-lg-4">
                    <div className="card shadow-sm h-100">
                        <div className="card-body">
                            <div style={{ height: '300px' }}>
                                <canvas ref={roomTypeChartRef}></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Detailed Table Section */}
            <div className="card shadow-sm">
                <div className="card-header bg-white py-3">
                    <div className="d-flex justify-content-between align-items-center mb-3">
                        <h5 className="mb-0">Booking Details</h5>
                        <button className="btn btn-success btn-sm" onClick={exportToExcel}>
                            <i className="bi bi-file-earmark-excel"></i> Export Table
                        </button>
                    </div>

                    {/* Client Filters Bar */}
                    <div className="row g-2">
                        <div className="col-md-4">
                            <input type="text" className="form-control" placeholder="Search Guest Name or ID..."
                                value={clientFilters.search}
                                onChange={e => setClientFilters({ ...clientFilters, search: e.target.value })} />
                        </div>
                        <div className="col-md-3">
                            <select className="form-select" value={clientFilters.roomType}
                                onChange={e => setClientFilters({ ...clientFilters, roomType: e.target.value })}>
                                <option value="all">All Room Types</option>
                                <option value="Standard Room">Standard Room</option>
                                <option value="Deluxe Room">Deluxe Room</option>
                                <option value="Suite">Suite</option>
                                <option value="Ocean View">Ocean View</option>
                            </select>
                        </div>
                        <div className="col-md-3">
                            <select className="form-select" value={clientFilters.status}
                                onChange={e => setClientFilters({ ...clientFilters, status: e.target.value })}>
                                <option value="all">All Statuses</option>
                                <option value="Pending">Pending</option>
                                <option value="Checked-In">Checked-In</option>
                                <option value="Cancelled">Cancelled</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div className="table-responsive">
                    <table className="table table-hover align-middle mb-0">
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
                            {loading ? (
                                <tr>
                                    <td colSpan="7" className="text-center py-5">
                                        <div className="spinner-border text-primary" role="status"></div>
                                        <p className="mt-2 text-muted">Loading data...</p>
                                    </td>
                                </tr>
                            ) : filteredBookings.length > 0 ? (
                                filteredBookings.map(b => (
                                    <tr key={b.id}>
                                        <td><span className="badge bg-light text-dark border">#{b.id}</span></td>
                                        <td className="fw-bold">{b.guestName}</td>
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
                                        <td className="text-end fw-bold text-success">${b.totalBill.toFixed(2)}</td>
                                    </tr>
                                ))
                            ) : (
                                <tr>
                                    <td colSpan="7" className="text-center py-5 text-muted">
                                        <i className="bi bi-inbox fs-1 d-block mb-2"></i>
                                        No bookings found matching your filters.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
                <div className="card-footer bg-light text-muted small">
                    Showing {filteredBookings.length} of {bookings.length} records
                </div>
            </div>
        </div>
    );
};

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<ReportsDashboard />);
