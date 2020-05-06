$ErrorActionPreference = 'stop'

$BaseDir = $PSScriptRoot
$FrameworkInitFlag = ".framework-initialized"
$OldPath = $Env:Path
$Env:Path += ";$Env:AppData\Python\Python38\Scripts"

function Command-Available {
    param($Command)
    try {
        (Get-Command $Command)
        return $True
    }
    catch {
        return $False
    }
}

# ensure pipenv available
if (!(Command-Available pipenv)) {
    "installing 'pipenv'"
    & pip3 install pipenv --user
}

try {
    # set working dir
    Push-Location $BaseDir

    # initialize framework if needed
    if (!(Test-Path $FrameworkInitFlag)) {
        "installing framework"
        pipenv install --three --ignore-pipfile
        New-Item -Name $FrameworkInitFlag -ItemType file | Out-Null
    }

    # run samples
    pipenv run behave $Args
}
finally {
    Pop-Location
    $Env:Path = $OldPath
}
