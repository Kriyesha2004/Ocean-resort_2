# Test Execution Guide

## Option 1: Maven (Recommended)

Maven automatically handles dependencies and test execution.

### Prerequisites
- Download Maven from https://maven.apache.org
- Add Maven to PATH

### Run Tests
```bash
mvn clean test
```

### Generate Test Report
```bash
mvn clean test site
# Report location: target/site/surefire-report.html
```

### Run Specific Test
```bash
mvn test -Dtest=LoginControllerTest
mvn test -Dtest=BillingServiceTest
```

---

## Option 2: Ant + Manual Test Compilation

### Download JUnit 5 Libraries

Create `lib/` directory and download:
- junit-jupiter-api-5.9.2.jar
- junit-jupiter-engine-5.9.2.jar
- junit-platform-console-5.9.2.jar
- mockito-core-5.2.0.jar
- mockito-junit-jupiter-5.2.0.jar

Or use the download script:
```bash
ant download-test-libs
```

### Compile Tests
```bash
ant compile-tests
```

### Run Tests
```bash
java -cp "build/test-classes;build/classes;lib/*" \
  org.junit.platform.console.ConsoleLauncher \
  --scan-classpath \
  --details=verbose
```

---

## Option 3: PowerShell Script (Windows)

```powershell
.\test.ps1 -Action run      # Run all tests
.\test.ps1 -Action report   # Generate report
```

---

## Test Files Located At

```
src/test/java/com/oceanview/
├── controller/
│   ├── LoginControllerTest
│   └── LogoutControllerTest
├── dao/
│   └── UserDAOTest
├── service/
│   ├── BillingServiceTest
│   └── ReservationServiceTest
└── util/
    └── DBConnectionTest
```

## Test Classes Overview

| Test Class | Purpose | Type |
|-----------|---------|------|
| **LoginControllerTest** | Tests login functionality | Unit + Mock |
| **LogoutControllerTest** | Tests logout/session termination | Unit + Mock |
| **UserDAOTest** | Tests user database operations | Integration |
| **BillingServiceTest** | Tests billing calculations | Unit |
| **ReservationServiceTest** | Tests reservation logic | Unit |
| **DBConnectionTest** | Tests database connectivity | Integration |

---

## JUnit 5 Features Used

✅ **Annotations**: `@Test`, `@BeforeEach`, `@DisplayName`
✅ **Mocking**: `@Mock`, `@InjectMocks` with Mockito
✅ **Parameterized Tests**: `@ParameterizedTest`, `@ValueSource`
✅ **Display Names**: Human-readable test descriptions
✅ **Assertions**: `assertEquals`, `assertTrue`, `assertNotNull`

---

## CI/CD Integration (GitHub Actions)

The workflow automatically runs tests on every push:

```yaml
- name: Run tests
  run: mvn clean test
```

Results available in GitHub Actions artifacts.

---

## Troubleshooting

**Tests won't compile**: Verify `src/test/java` directory structure matches package names

**Mock errors**: Ensure `@ExtendWith(MockitoExtension.class)` is on test class

**Database tests fail**: Verify MySQL is running and schema is created

---

## Next Steps

1. Run `mvn clean test` to execute all tests
2. Check GitHub Actions for CI/CD results
3. Review test coverage in reports
4. Add more tests as you develop features
