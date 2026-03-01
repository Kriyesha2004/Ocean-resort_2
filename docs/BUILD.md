# Build & Deployment Guide

## 📋 Overview

Ocean View Resort uses a Java/JSP MVC architecture deployed to Apache Tomcat. This guide covers local development and CI/CD workflows.

---

## 🛠️ Local Development Setup

### Prerequisites

- **Java 11+** - Download from [java.com](https://www.java.com)
- **Apache Tomcat 9.0+** - Available in XAMPP
- **Git** (for version control)
- **PowerShell 5.1+** (Windows) or Bash (Linux/Mac)

### Quick Start

#### Option 1: PowerShell Script (Windows)

```powershell
# Build only
.\deploy.ps1 -Action build

# Build and deploy
.\deploy.ps1 -Action deploy

# Clean build artifacts
.\deploy.ps1 -Action clean
```

#### Option 2: Ant Build

```bash
# Compile classes
ant build

# Package as WAR
ant package

# Deploy to Tomcat
ant deploy

# Full rebuild
ant rebuild
```

#### Option 3: Manual Compilation

```bash
cd WEB-INF/classes

# Compile all Java files
javac -cp "C:\xampp\tomcat\lib\servlet-api.jar;." \
  -d . \
  com/oceanview/**/*.java
```

---

## 📁 Project Structure

```
Ocean-resort_2/
├── WEB-INF/
│   ├── classes/
│   │   └── com/oceanview/
│   │       ├── controller/    (11 controllers)
│   │       ├── dao/           (4 DAOs)
│   │       ├── dto/           (3 DTOs)
│   │       ├── model/         (3 models)
│   │       ├── service/       (2 services)
│   │       └── util/          (1 utility)
│   ├── lib/
│   └── web.xml
├── *.jsp files              (View layer)
├── css/                     (Stylesheets)
├── js/                      (JavaScript)
├── sql/                     (Database scripts)
├── docs/                    (Documentation)
├── build.xml               (Ant build file)
├── deploy.ps1              (PowerShell script)
└── .github/workflows/
    └── ci.yml              (GitHub Actions)
```

---

## 🏗️ Build Process

### Step 1: Compile Java Classes

The build process compiles all Java files in the MVC layers:

```
Model Layer (util) → DAO Layer → DTO Layer → Service Layer → Controller Layer
```

Each layer's dependencies are compiled in order.

### Step 2: Verify Compilation

Check for compiled `.class` files:

```powershell
Get-ChildItem -Path "WEB-INF\classes\com\oceanview" -Recurse -Filter "*.class"
```

Should show **24 compiled classes**:
- Controllers: 11
- DAOs: 4  
- DTOs: 3
- Models: 3
- Services: 2
- Utilities: 1

### Step 3: Package Application

Optional WAR packaging for distribution:

```bash
ant package
```

Creates `dist/Ocean-resort_2.war`

---

## 🚀 Deployment

### Deployment to Tomcat

1. **Compile** the project (see Build Process above)

2. **Copy files** to Tomcat:
   ```
   C:\xampp\tomcat\webapps\Ocean-resort_2\
   ├── WEB-INF/classes/     ← compiled .class files
   ├── *.jsp
   ├── css/
   ├── js/
   └── ...
   ```

3. **Restart Tomcat**:
   ```
   C:\xampp\tomcat\bin\shutdown.bat
   C:\xampp\tomcat\bin\startup.bat
   ```

4. **Access application**:
   ```
   http://localhost:8080/Ocean-resort_2
   ```

### Using PowerShell Deploy Script

```powershell
.\deploy.ps1 -Action deploy
```

This automatically:
- Compiles all Java classes
- Copies to Tomcat deployment directory
- Shows deployment status
- Displays access URL

---

## 🔄 Continuous Integration (GitHub Actions)

### Workflow File
Located at: `.github/workflows/ci.yml`

### What the Workflow Does

1. **Checkout** code from repository
2. **Setup Java 11** environment
3. **Compile** all Java classes
4. **Verify** compilation success
5. **Package** as WAR artifact
6. **Upload** artifact for download

### Running the Workflow

Automatically triggered on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`

Manual trigger (GitHub web UI):
1. Go to Actions tab
2. Select "Build & Compile MVC Application"
3. Click "Run workflow"

### View Workflow Results

1. GitHub repository → Actions tab
2. Select run
3. View build logs and download artifacts

---

## 📊 Build Artifacts

### Local Build Output
```
build/
└── classes/
    └── com/oceanview/
        ├── controller/
        ├── dao/
        ├── dto/
        ├── model/
        ├── service/
        └── util/
```

### CI/CD Artifact
- **Name**: `ocean-resort-app`
- **File**: `Ocean-resort_2.war`
- **Retention**: 30 days
- **Download**: From GitHub Actions run

---

## 🐛 Troubleshooting

### Compilation Errors

**Error**: `package javax.servlet does not exist`
- **Solution**: Add servlet-api.jar to classpath when compiling

**Error**: `bad class file: wrong version 69.0, should be 55.0`
- **Solution**: Clean all .class files and recompile
  ```powershell
  .\deploy.ps1 -Action clean
  .\deploy.ps1 -Action build
  ```

### Deployment Issues

**Application not loading after deployment**
- Restart Tomcat completely (shutdown → startup)
- Check Tomcat logs: `C:\xampp\tomcat\logs\catalina.out`

**Port 8080 already in use**
- Change port in: `C:\xampp\tomcat\conf\server.xml`
- Or kill process: `netstat -ano | findstr :8080`

---

## 📝 Build Configuration Files

### `build.xml` (Ant)
- Builds Java classes
- Packages WAR file
- Deploys to Tomcat
- Cleans artifacts

**Key targets**:
- `ant clean` - Remove build artifacts
- `ant build` - Compile classes
- `ant package` - Create WAR file
- `ant deploy` - Deploy to Tomcat

### `deploy.ps1` (PowerShell)
- Compiles Java classes
- Shows build summary
- Deploys to Tomcat
- Displays deployment status

**Usage**:
```powershell
.\deploy.ps1 -Action [build|deploy|clean]
```

### `.github/workflows/ci.yml` (GitHub Actions)
- Runs on push/PR to main/develop
- Compiles with Java 11
- Creates WAR artifact
- Shows build summary

---

## ✅ Verification Checklist

After building:

- [ ] All Java files compile without errors
- [ ] 24 .class files generated
- [ ] No broken imports
- [ ] Controllers package exists and contains 11 classes
- [ ] DAO package contains 4 classes
- [ ] DTO package contains 3 classes
- [ ] Can access app at `http://localhost:8080/Ocean-resort_2`
- [ ] Login with `admin` / `admin123`
- [ ] Dashboard loads without errors

---

## 🔗 Related Documentation

- [MVC_REFACTORING.md](MVC_REFACTORING.md) - Architecture details
- [ARCHITECTURE.md](ARCHITECTURE.md) - System design
- [README.md](../README.md) - Project overview

---

## 📞 Support

For build issues or questions:
1. Check the log files in `C:\xampp\tomcat\logs\`
2. Verify Java version: `java -version`
3. Review GitHub Actions logs for CI/CD issues
4. Check compilation errors carefully for import/syntax issues

---

**Last Updated**: March 1, 2026  
**Status**: ✅ Ready for Development & Deployment
