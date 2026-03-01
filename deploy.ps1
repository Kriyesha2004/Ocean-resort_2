param([ValidateSet("build", "deploy", "clean", "test")][string]$Action = "build")

$ProjectRoot = "C:\xampp\tomcat\webapps\Ocean-resort_2"
$TomcatHome = "C:\xampp\tomcat"
$SourceDir = "C:\xampp\tomcat\webapps\Ocean-resort_2\src\main\java"
$BuildDir = "C:\xampp\tomcat\webapps\Ocean-resort_2\target\classes"
$WebInfClasses = "C:\xampp\tomcat\webapps\Ocean-resort_2\WEB-INF\classes"
$DeployDir = "C:\xampp\tomcat\webapps\Ocean-resort_2"

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "Ocean View Resort - Build Deploy Script" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

if ($Action -eq "clean") {
    Write-Host "`nCleaning artifacts..." -ForegroundColor Yellow
    Get-ChildItem -Path $WebInfClasses -Filter "*.class" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force
    if (Test-Path $BuildDir) {
        Remove-Item -Path $BuildDir -Recurse -Force
    }
    Write-Host "Cleaned build artifacts and WEB-INF/classes" -ForegroundColor Green
}

elseif ($Action -eq "test") {
    Write-Host "`nRunning unit tests with Maven..." -ForegroundColor Yellow
    
    # Check if Maven is installed
    $mavenPath = (Get-Command mvn -ErrorAction SilentlyContinue).Source
    if (-not $mavenPath) {
        Write-Host "Maven not found. Please install Maven from https://maven.apache.org" -ForegroundColor Red
        Write-Host "Or use: test-standalone.ps1 for standalone test execution" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "Running: mvn clean test" -ForegroundColor Gray
    mvn clean test
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`nTests passed successfully!" -ForegroundColor Green
        Write-Host "Test Report: target/site/surefire-report.html" -ForegroundColor Cyan
    } else {
        Write-Host "`nSome tests failed. Check output above." -ForegroundColor Red
    }
}

elseif ($Action -eq "build" -or $Action -eq "deploy") {
    Write-Host "`nCompiling Java files from src/main/java..." -ForegroundColor Yellow
    
    # Create target/classes directory if it doesn't exist
    if (-not (Test-Path $BuildDir)) {
        New-Item -ItemType Directory -Path $BuildDir -Force | Out-Null
    }
    
    $JavaFiles = Get-ChildItem -Path $SourceDir -Filter "*.java" -Recurse | ForEach-Object { $_.FullName }
    $ClassPath = "$TomcatHome\lib\servlet-api.jar"
    
    # Compile from src/main/java to target/classes
    & javac -cp $ClassPath -d $BuildDir $JavaFiles 2>&1 | Select-Object -First 20
    
    if ($LASTEXITCODE -eq 0) {
        $Classes = @(Get-ChildItem -Path $BuildDir -Filter "*.class" -Recurse)
        Write-Host "Success - $($Classes.Count) classes compiled" -ForegroundColor Green
        
        if ($Action -eq "deploy") {
            Write-Host "`nDeploying compiled classes to Tomcat WEB-INF/classes..." -ForegroundColor Yellow
            Copy-Item -Path "$BuildDir\*" -Destination $WebInfClasses -Recurse -Force
            Write-Host "Deployed successfully" -ForegroundColor Green
            Write-Host "`nAccess: http://localhost:8080/Ocean-resort_2" -ForegroundColor Cyan
            Write-Host "Restart Tomcat to load new classes" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Compilation failed" -ForegroundColor Red
    }
}

Write-Host "`n"
