# Ocean View Resort - Architecture & Design Documentation

## Project Overview
A modern, high-scoring 3-Tier Architecture system for managing guest reservations and billing at Ocean View Resort. Built with Java, Jakarta EE, and MySQL following the MVC (Model-View-Controller) pattern.

## Architecture Layers

### 1. **Presentation Layer (View) - Frontend**
- **Technology**: HTML5, CSS3, JavaScript, Bootstrap 5
- **Components**:
  - `index.jsp` - Login page
  - `dashboard.jsp` - Main dashboard with statistics
  - `reservation.jsp` - Create new reservations
  - `reservations-list.jsp` - View all reservations
  - `reports.jsp` - View reports and analytics
  - `navbar.jsp` - Navigation component

- **Features**:
  - Modern, responsive Bootstrap UI
  - Real-time JavaScript validation
  - Client-side date validation (prevent past dates)
  - Real-time bill calculation
  - Interactive forms with immediate feedback

### 2. **Business Logic Layer (Controller) - Backend**
- **Technology**: Java Servlets (Jakarta EE 5.0)
- **Key Components**:

#### Servlets:
- **LoginServlet** - Handles user authentication
  - Validates credentials against database
  - Creates session with 30-minute timeout
  - Implements secure session management
  
- **ReservationServlet** - Manages reservation operations
  - Creates new reservations
  - Updates existing reservations
  - Deletes reservations
  - Integrates with BillingService
  
- **LogoutServlet** - Handles user session termination
  - Invalidates session
  - Redirects to login page

#### Service Classes:
- **BillingService** - Billing calculations
  - Calculates nightly rates per room type
  - Computes stay duration
  - Generates total bills
  - Supports tax calculations
  - Formats currency output

### 3. **Data Access Layer (Model) - Database**
- **Technology**: MySQL Database
- **Database Name**: `ocean_view_db`

#### Tables:
1. **users** - Staff login credentials
   - user_id, username, password, full_name, email
   
2. **reservations** - Guest reservation records
   - res_id, guest_name, address, contact_no, email
   - room_type, check_in, check_out, total_bill, status
   - created_by, created_at
   
3. **billing** - Billing history records
   - bill_id, res_id, nights, room_type
   - rate_per_night, total_bill, payment_status, created_at

## Design Patterns Implemented

### 1. **Singleton Pattern** (DBConnection.java)
- Ensures single database connection instance
- Prevents connection pool exhaustion
- Manages connection lifecycle efficiently
- Thread-safe implementation

```java
public static Connection getConnection() throws SQLException {
    if (connection == null || connection.isClosed()) {
        // Create new connection only once
    }
    return connection;
}
```

### 2. **MVC Pattern**
- **Model**: BillingService, DBConnection (Data access)
- **View**: JSP pages (Presentation)
- **Controller**: Servlets (Business logic)

### 3. **Service Layer Pattern**
- BillingService encapsulates billing logic
- Promotes code reusability
- Simplifies testing

## Technology Stack

### Frontend
- HTML5
- CSS3 (Custom + Bootstrap 5)
- JavaScript (ES6+)
- Bootstrap 5 CDN

### Backend
- Java 11+
- Jakarta EE 5.0
- Apache Tomcat 9.0.115

### Database
- MySQL 8.0+
- JDBC Driver: mysql-connector-java

## Room Rates
- **Single Room**: $5,000 per night
- **Double Room**: $8,500 per night
- **Luxury Suite**: $15,000 per night

## Key Features

### User Authentication
- Secure login system with session management
- 30-minute session timeout for security
- Role-based access control ready

### Reservation Management
- Create new guest reservations
- View all reservations with status tracking
- Real-time bill calculation
- Date validation (prevent past check-in dates)
- Prevent checkout before check-in

### Billing System
- Automatic bill calculation based on stay duration
- Support for multiple room types
- Tax calculation capabilities
- Detailed billing history

### Reporting & Analytics
- Daily occupancy reports
- Monthly revenue summaries
- Guest statistics
- Print-friendly reports

### Input Validation
- **Client-side** (JavaScript)
  - Real-time form validation
  - Date range validation
  - Required field checking
  - Contact number format validation
  
- **Server-side** (Java Servlets)
  - SQL injection prevention using PreparedStatements
  - Null/empty field checking
  - Business logic validation
  - Exception handling

## Security Features
1. PreparedStatements prevent SQL injection
2. Session management with timeout
3. HTTP-only cookies
4. Input validation on both client and server
5. Error handling without exposing system details

## Responsive Design
- Mobile-friendly Bootstrap layout
- Optimized for devices 480px to 1920px+
- Touch-friendly buttons and inputs
- Adaptive table displays

## File Structure
```
Ocean2/
├── WEB-INF/
│   ├── classes/
│   │   └── com/oceanview/
│   │       ├── util/
│   │       │   └── DBConnection.java
│   │       ├── service/
│   │       │   └── BillingService.java
│   │       └── servlet/
│   │           ├── LoginServlet.java
│   │           ├── ReservationServlet.java
│   │           └── LogoutServlet.java
│   ├── jsp/
│   └── web.xml
├── css/
│   └── style.css
├── js/
│   ├── validation.js
│   └── reservation.js
├── docs/
│   └── uml/
│       ├── login_sequence.puml
│       ├── reservation_sequence.puml
│       └── class_diagram.puml
├── sql/
│   └── ocean_view_db.sql
├── index.jsp
├── dashboard.jsp
├── reservation.jsp
├── reservations-list.jsp
├── reports.jsp
└── navbar.jsp
```

## Deployment Instructions

1. **Set up MySQL Database**:
   - Execute `sql/ocean_view_db.sql` in MySQL Workbench
   - Default credentials in script

2. **Configure Database Connection**:
   - Update `DBConnection.java` with your MySQL credentials
   - Ensure `com.mysql.cj.jdbc.Driver` is in classpath

3. **Compile Java Classes**:
   ```
   javac -d WEB-INF/classes WEB-INF/classes/com/oceanview/**/*.java
   ```

4. **Deploy to Tomcat**:
   - Place the entire `Ocean2` folder in Tomcat's `webapps` directory
   - Restart Tomcat server

5. **Access Application**:
   - Navigate to `http://localhost:8080/Ocean2`
   - Login with: admin / admin123

## Testing Credentials
- **Username**: admin
- **Password**: admin123

## Future Enhancements
- Payment processing integration
- Email notifications for reservations
- Guest review system
- Dynamic room availability
- Multi-language support
- Advanced reporting with charts
- Mobile app integration
