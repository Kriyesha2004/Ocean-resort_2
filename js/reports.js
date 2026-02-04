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

    const exportToExcel = () => {
        const ws = XLSX.utils.json_to_sheet(filteredBookings);
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Reports");
        XLSX.writeFile(wb, `Reports_${sqFilters.year}_${sqFilters.month}.xlsx`);
    };

    const exportToWord = async () => {
        const { Document, Packer, Paragraph, TextRun, ImageRun, Table, TableRow, TableCell, WidthType, HeadingLevel, AlignmentType } = docx;

        // 1. Capture Charts
        const revenueChartUrl = revenueChartRef.current.toDataURL();
        const roomChartUrl = roomTypeChartRef.current.toDataURL();

        // 2. Create Table Rows
        const tableRows = filteredBookings.map(b => (
            new TableRow({
                children: [
                    new TableCell({ children: [new Paragraph(b.id.toString())] }),
                    new TableCell({ children: [new Paragraph(b.guestName)] }),
                    new TableCell({ children: [new Paragraph(b.roomType)] }),
                    new TableCell({ children: [new Paragraph(b.checkIn)] }),
                    new TableCell({ children: [new Paragraph(b.status)] }),
                    new TableCell({ children: [new Paragraph("$" + b.totalBill.toFixed(2))] }),
                ],
            })
        ));

        // Add Header Row
        tableRows.unshift(new TableRow({
            children: [
                new TableCell({ children: [new Paragraph({ text: "ID", bold: true })] }),
                new TableCell({ children: [new Paragraph({ text: "Guest", bold: true })] }),
                new TableCell({ children: [new Paragraph({ text: "Room", bold: true })] }),
                new TableCell({ children: [new Paragraph({ text: "Check-In", bold: true })] }),
                new TableCell({ children: [new Paragraph({ text: "Status", bold: true })] }),
                new TableCell({ children: [new Paragraph({ text: "Bill", bold: true })] }),
            ],
            tableHeader: true,
        }));

        // 3. Create Document
        const doc = new Document({
            sections: [{
                properties: {},
                children: [
                    new Paragraph({
                        text: "Ocean View Resort - Reports",
                        heading: HeadingLevel.HEADING_1,
                        alignment: AlignmentType.CENTER,
                    }),
                    new Paragraph({
                        text: `Scope: Year ${sqFilters.year}, Month: ${sqFilters.month === 'all' ? 'All' : sqFilters.month}`,
                        alignment: AlignmentType.CENTER,
                    }),
                    new Paragraph({ text: "" }), // Spacer

                    // Stats
                    new Paragraph({
                        children: [
                            new TextRun({ text: `Total Bookings: ${dynamicStats.count}`, bold: true, break: 1 }),
                            new TextRun({ text: `Total Revenue: $${dynamicStats.revenue.toFixed(2)}`, bold: true, break: 1 }),
                            new TextRun({ text: `Checked-In: ${dynamicStats.checkedIn}`, bold: true, break: 1 }),
                        ]
                    }),
                    new Paragraph({ text: "" }), // Spacer

                    // Charts
                    new Paragraph({
                        children: [
                            new ImageRun({
                                data: revenueChartUrl,
                                transformation: { width: 500, height: 300 },
                            }),
                        ],
                        alignment: AlignmentType.CENTER,
                    }),
                    new Paragraph({ text: "" }), // Spacer
                    new Paragraph({
                        children: [
                            new ImageRun({
                                data: roomChartUrl,
                                transformation: { width: 300, height: 300 },
                            }),
                        ],
                        alignment: AlignmentType.CENTER,
                    }),
                    new Paragraph({ text: "" }), // Spacer

                    // Table
                    new Paragraph({ text: "Booking Details", heading: HeadingLevel.HEADING_2 }),
                    new Table({
                        rows: tableRows,
                        width: { size: 100, type: WidthType.PERCENTAGE },
                    }),
                ],
            }],
        });

        // 4. Save
        Packer.toBlob(doc).then(blob => {
            saveAs(blob, `Reports_${sqFilters.year}_${sqFilters.month}.docx`);
        });
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
                        <div className="d-flex align-items-end gap-2">
                            <button className="btn btn-success btn-sm" onClick={exportToExcel}>
                                <i className="bi bi-file-earmark-excel"></i> Export Table
                            </button>
                            <button className="btn btn-primary btn-sm" onClick={exportToWord}>
                                <i className="bi bi-file-word"></i> Export Word
                            </button>
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


        </div>
    );
};

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<ReportsDashboard />);
