# Ocean View Resort (Ocean-resort_2)

A Java/Jakarta EE web application for managing guest reservations and billing for Ocean View Resort. The app follows a 3‑tier MVC architecture with JSPs on the frontend, Java Servlets/services in the middle tier, and a MySQL database in the data tier. This repository contains the JSP views, Java classes (under `WEB-INF/classes`), static assets, and SQL schema to run the application locally.

## Features

- Secure login with session management (30‑minute timeout)
- Reservation creation, update, and listing
- Real‑time bill calculation by room type and stay duration
- Client‑side and server‑side validation
- Reporting and analytics views
- Responsive Bootstrap UI

## Tech Stack

- **Frontend**: JSP, HTML5, CSS3, JavaScript, Bootstrap 5
- **Backend**: Java 11+, Jakarta EE 5.0 (Servlets)
- **Database**: MySQL 8.0+
- **Server**: Apache Tomcat 9.0.115

## Project Structure

```
WEB-INF/
  classes/com/oceanview/
    util/DBConnection.java
    service/BillingService.java
    servlet/LoginServlet.java
    servlet/ReservationServlet.java
    servlet/LogoutServlet.java
css/
js/
sql/ocean_view_db.sql
docs/ARCHITECTURE.md
*.jsp
```

## Getting Started

### 1) Create the database

Run the SQL script in `sql/ocean_view_db.sql`:

```sql
-- Example (MySQL CLI)
SOURCE /path/to/sql/ocean_view_db.sql;
```

### 2) Configure database credentials

Update the JDBC settings in `WEB-INF/classes/com/oceanview/util/DBConnection.java` to match your local MySQL credentials and host.

### 3) Compile Java classes

From the repo root:

```bash
javac -d WEB-INF/classes WEB-INF/classes/com/oceanview/**/*.java
```

### 4) Deploy to Tomcat

1. Copy the entire project directory (e.g., `Ocean-resort_2`) into Tomcat’s `webapps` folder.
2. Restart Tomcat.
3. Open: `http://localhost:8080/Ocean-resort_2`

## Default Credentials

- **Username**: `admin`
- **Password**: `admin123`

## Room Rates

- **Single Room**: $5,000/night
- **Double Room**: $8,500/night
- **Luxury Suite**: $15,000/night

## Documentation

See `docs/ARCHITECTURE.md` for the detailed architecture, design patterns, and deployment notes.

## Notes

- Ensure the MySQL JDBC driver is available to your Tomcat instance.
- Update any context path references if you rename the project folder.

## License

No license specified. Add a LICENSE file if you intend to open‑source this project.
