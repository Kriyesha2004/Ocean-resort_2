# MVC Refactoring Documentation

## Overview

The Ocean View Resort project has been successfully refactored to follow a comprehensive **Model-View-Controller (MVC)** architectural pattern with dedicated layers for each concern. This document outlines the new structure and the benefits of this refactoring.

## Architecture Layers

### 1. **Controller Layer** (`com.oceanview.controller`)

**Purpose**: Handles HTTP requests and responses, orchestrates business logic flow, and manages user interactions.

**Classes**:
- `LoginController` - User authentication and session management
- `LogoutController` - Session termination
- `ReservationController` - Reservation CRUD operations (create, read, update, delete)
- `CalendarController` - Calendar event data retrieval (JSON API)
- `NotificationController` - Real-time notifications (JSON API)
- `ReportsController` - Analytics and reporting (JSON API)
- `SettingsController` - User preferences management
- `StaffController` - Staff member CRUD operations (admin)
- `UpdateRoomController` - Room details and status updates
- `UpdateRoomTypeController` - Room type pricing and capacity management
- `MessageController` - Messaging operations

**Key Characteristics**:
- Annotated with `@WebServlet` for automatic servlet registration
- Handles request forwarding and redirection
- Sets attributes for JSP views
- Manages session handling
- No direct database calls (delegates to DAOs and Services)

---

### 2. **Data Transfer Object (DTO) Layer** (`com.oceanview.dto`)

**Purpose**: Encapsulates data transfer between layers without exposing domain models directly.

**Classes**:
- `UserDTO` - User information transfer object
  - userId, username, password, fullName, email
  - Settings: isDarkMode, isEmailNotif, isBrowserNotif
  - createdAt timestamp

- `RoomDTO` - Room information transfer object
  - roomId, roomNumber, roomType, status

- `RoomTypeDTO` - Room type information transfer object
  - typeId, typeName, price, description
  - imageUrl, capacity

**Benefits**:
- Separates business domain models from API contracts
- Allows flexible data transformations
- Provides version compatibility and evolution strategy
- Encapsulates sensitive data hiding

---

### 3. **Model Layer** (`com.oceanview.model`)

**Purpose**: Represents core business domain objects with business logic and behavior.

**Classes**:
- `User` - User entity with getters/setters
- `Room` - Room entity
- `RoomType` - Room type entity

**Current Implementation**: Models are mostly plain Java objects (getters/setters). Can be enhanced with business logic and validation methods.

---

### 4. **DAO Layer** (`com.oceanview.dao`)

**Purpose**: Handles all database operations and CRUD logic.

**Classes**:
- `UserDAO` - User database operations
  - `getUserByUsername()` - Retrieve user by username
  - `getAllUsers()` - Get all users
  - `addUser()` - Add new user
  - `updateUser()` - Update user info
  - `updateSettings()` - Update user preferences
  - `deleteUser()` - Delete user

- `RoomDAO` - Room database operations
  - `getRoomById()` - Retrieve room by ID
  - `getAllRooms()` - Get all rooms
  - `addRoom()` - Add new room
  - `updateRoom()` - Update room details
  - `deleteRoom()` - Delete room

- `RoomTypeDAO` - Room type database operations
  - Similar CRUD operations for room types

- `MessageDAO` - Message database operations
  - `createMessage()` - Send messages

**Key Principles**:
- Only performs JDBC operations
- Returns model/DTO objects
- Handles SQL exceptions internally
- Uses try-with-resources for resource management

---

### 5. **Service Layer** (`com.oceanview.service`)

**Purpose**: Contains business logic and orchestrates DAOs for complex operations.

**Classes**:
- `ReservationService` - Reservation business operations
  - `findAvailableRoom()` - Check room availability for date range
  - Complex availability logic

- `BillingService` - Billing calculations
  - `calculateBill()` - Calculate total bill for stay
  - `calculateNights()` - Calculate number of nights
  - `getRatePerNight()` - Get rate per night for room type

**Key Characteristics**:
- Encapsulates business rules
- Uses DAOs for data access
- Can be tested independently
- Reusable across multiple controllers

---

### 6. **Utility Layer** (`com.oceanview.util`)

**Purpose**: Provides common utilities and helper functions.

**Classes**:
- `DBConnection` - Database connection pooling and JDBC utilities
  - `getConnection()` - Get database connection

---

### 7. **View Layer** (JSP files in webroot)

**Purpose**: Presentation layer that displays data to users.

**Key JSP Files**:
- `index.jsp` - Login page
- `dashboard.jsp` - User dashboard
- `admin_dashboard.jsp` - Admin dashboard
- `reservation.jsp` - Create/view reservations
- `admin-rooms.jsp` - Room management
- `admin-staff.jsp` - Staff management
- `settings.jsp` - User settings
- And many more...

**View Characteristics**:
- Pure presentation logic
- Receives data from controllers via request attributes
- Never directly access the database
- Use JSTL for control flow

---

## Request Flow (MVC Cycle)

```
Client Request
↓
Controller (receives request)
↓
Service (business logic processing)
↓
DAO (database operations)
↓
Model (data representation)
↓
Service (returns processed data)
↓
Controller (sets attributes & forwards)
↓
View/JSP (renders response)
↓
Client Response
```

---

## Migration from Servlet Package to Controller Package

The original `com.oceanview.servlet` package contained servlet classes that mixed multiple concerns. These have been refactored into the `controller` package with improved separation of concerns.

### Changes Made:

1. **Package Rename**: `servlet` → `controller`
   - Renamed servlet classes to `*Controller` naming convention
   - Updated `@WebServlet` annotations remain the same
   - No changes needed to `web.xml` (uses annotation-based routing)

2. **Import Updates**: All imports from `com.oceanview.servlet` now reference the new controller classes

3. **Direct DAO Usage**: Controllers directly use DAO classes for CRUD operations

4. **Service Integration**: Controllers delegate business logic to Service layer classes

### Old Servlet Classes

The original servlet classes are retained in `com.oceanview.servlet` for reference. These can be removed after ensuring the new controllers are working correctly.

---

## Compilation

All Java classes have been compiled successfully without errors. The compiled `.class` files are located under `WEB-INF/classes/com/oceanview/`.

**Compilation Command** (with servlet-api.jar)
```bash
javac -cp "c:\xampp\tomcat\lib\servlet-api.jar;." -d . com/oceanview/**/*.java
```

---

## Deployment

1. The refactored project is ready to deploy to Tomcat
2. Copy the entire project directory to `tomcat/webapps/`
3. Restart Tomcat to pick up the new compiled classes
4. Access via: `http://localhost:8080/Ocean-resort_2`

---

## Benefits of This Architecture

### ✅ **Separation of Concerns**
- Each layer has a single, well-defined responsibility
- Controllers handle HTTP, DAOs handle DB, Services handle business logic

### ✅ **Testability**
- Each layer can be unit tested independently
- Services can be tested without the web layer
- DAOs can be tested with mock data

### ✅ **Maintainability**
- Clear structure makes code easier to understand
- Changes to database logic only affect DAO layer
- Business rules changes only affect Service layer

### ✅ **Reusability**
- Services can be used by multiple controllers
- DAOs provide consistent data access
- DTOs can be serialized to JSON easily

### ✅ **Scalability**
- Easy to add new features following the established patterns
- New controllers follow the same structure
- Business logic in services is reusable

---

## Future Enhancements

### Recommended Improvements:

1. **Add a Repository Pattern**: Create an abstraction layer above DAOs for more flexibility

2. **Implement Exception Handling**: Create custom exceptions and centralized error handling

3. **Add Dependency Injection**: Use Spring or a lightweight DI framework to reduce tight coupling

4. **Add Caching Layer**: Implement caching for frequently accessed data

5. **Create API Response Wrappers**: Standardize API responses with status codes and messages

6. **Add Validation Layer**: Create a dedicated validation service for input validation

7. **Implement Logging**: Add proper logging using SLF4J or Log4j

8. **Create Integration Tests**: Add tests for the complete request/response cycle

9. **Add API Documentation**: Generate Swagger/OpenAPI documentation for APIs

10. **Implement Configuration Management**: Externalize configuration to properties files

---

## Package Structure Summary

```
com/oceanview/
├── controller/     (11 classes) - HTTP request handling
├── dto/            (3 classes)  - Data transfer objects
├── model/          (3 classes)  - Domain objects
├── dao/            (4 classes)  - Database access objects
├── service/        (2 classes)  - Business logic
├── servlet/        (11 classes) - Legacy servlet classes (optional to remove)
└── util/           (1 class)    - Utility functions
```

**Total: 35+ compiled Java classes following the MVC pattern**

---

## Contact & Questions

For questions about this refactoring or the MVC architecture, refer to the main README.md or the ARCHITECTURE.md file in the docs folder.

---

**Last Updated**: March 1, 2026
**Status**: ✅ Complete - All classes compiled and ready for deployment
