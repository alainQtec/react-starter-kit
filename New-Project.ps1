<#
.SYNOPSIS
  Creates a new react project
.DESCRIPTION
  Long description
.EXAMPLE
  New-reactp -projectName $Name
  Explanation of what the example does
.NOTES
  General notes
#>
param (
  # Project name
  [Parameter(Mandatory = $false)]
  [string]$projectName = "My-React-app",
  [Parameter(Mandatory = $false)]
  [switch]$Force
)
$configfiles = [ordered]@{
  editor       = @(".editorconfig", "root = true`n`n[*]`nindent_style = space`nindent_size = 2`nend_of_line = lf`ncharset = utf-8`n`n[*.py]`nindent_size = 4`nmax_line_length = 80`n`n[*.json]`ninsert_final_newline = ignore`n`n[**.min.js]`nindent_style = ignore`ninsert_final_newline = ignore`n`n[Makefile]`nindent_style = tab`n`n[*.bat]`nindent_style = tab`n`n[*.md]`ntrim_trailing_whitespace = false`n`n")
  eslint       = @(".eslintrc.js" , "module.exports = { `nenv: { `n`"es6`": true, `n`"browser`": true, `n`"node`": true`n }, `nextends: [`n`"airbnb`", `n`"prettier`", `n`"plugin:jest/recommended`", `n`"jest-enzyme`"`n], `nparser: `"babel-eslint`", `nplugins: [`n`"prettier`", `n`"babel`", `n`"import`", `n`"jsx-a11y`", `n`"react`"`n], `nrules: { `n`"prettier/prettier`": [`"error`"], `n`"react/jsx-filename-extension`": 0, `n`"no-unused-vars`": 0`n }`n }`n")
  eslintignore = @(".eslintignore", "/.git/**`nnode_modules/**`ndist/**")
  enzyme       = @("enzyme.config.js" , "import { configure } from 'enzyme';`nimport Adapter from 'enzyme-adapter-react-16';`n`nconfigure({ adapter: new Adapter() });")
  jest         = @("jest.config.js" , "module.exports = { `n clearMocks: true, `n collectCoverageFrom: ['src/**/*.{js,jsx,mjs}'], `n coverageDirectory: 'coverage', `n moduleFileExtensions: ['js', 'json', 'jsx'], `n setupFiles: ['./enzyme.config.js'], `n snapshotSerializers: ['enzyme-to-json/serializer'], `n testEnvironment: 'jsdom', `n testMatch: ['**/__tests__/**/*.js?(x)', '**/?(*.)+(spec|test).js?(x)'], `n testPathIgnorePatterns: ['\\\\node_modules\\\\'], `n testURL: 'http://localhost', `n transformIgnorePatterns: ['./node_modules/'], `n verbose: true,};")
  prettier     = @("prettier.config.js" , "module.exports = {`n  printWidth: 100,`n  singleQuote: true,`n  trailingComma: 'all',`n  bracketSpacing: true,`n  jsxBracketSameLine: false,`n  tabWidth: 2,`n  semi: true,`n};")
  stylelint    = @(".stylelintrc" , "{`n  `"processors`": [`n  `"stylelint-processor-styled-components`"`n  ],`n  `"extends`": [`n  `"stylelint-config-recommended`",`n  `"stylelint-config-styled-components`"`n  ]`n}")
  gitignore    = @(".gitignore" , "/node_modules`n/dist`n.env*")
  webpack      = @("webpack.config.js" , "const HTMLWebPackPlugin = require('html-webpack-plugin');`nconst StyleLintPlugin = require('stylelint-webpack-plugin');`n`nmodule.exports = {`n  module: {`n    rules: [`n    {`n      test: /\.(js | jsx)$/,`n      exclude: /node_modules/,`n      use: [`n      {`n        loader: 'babel-loader',`n      },`n      ],`n    },`n    {`n      test: /\.html$/,`n      use: [`n      {`n        loader: 'html-loader',`n      },`n      ],`n    },`n    ],`n  },`n  plugins: [`n  new HTMLWebPackPlugin( {`n      template: './src/index.html',`n      filename: './index.html',`n    }),`n  new StyleLintPlugin( {`n      configFile: '.stylelintrc',`n      context: 'src/style',`n      files: '**/*.js',`n      failOnError: false,`n      quiet: false,`n      emitErrors: true,`n    }),`n  ],`n};")
  husky        = @(".huskyrc.js", "module.exports = {`n  hooks: {`n    'pre-commit': 'lint-staged',`n    'pre-push': 'npm run pretty'`n  }`n};`n")
  staged       = @("lint-staged.config.js", "module.exports = {`n  linters: {`n    'src/**/*.js': ['npm run lint', 'npm run style', 'npm run test', 'npm run coverage', 'git add'],`n  },`n};`n")
}

$npmpack = [ordered]@{
  name         = "package.json"
  contents     = "{`n`"name`": `"$projectName`",`n`"version`": `"1.0.0`",`n`"description`": `"$projectName`",`n`"main`": `"src/index.js`",`n`"scripts`": {`n`"test`": `"jest`",`n`"watch`": `"jest --watch`",`n`"coverage`": `"jest --coverage --colors`",`n`"start`": `"webpack-dev-server --open --hot --mode development`",`n`"build`": `"webpack --mode production`",`n`"lint`": `"eslint --debug src/**/*.js`",`n`"style`": `"stylelint src/**/*.{js,css,scss}`",`n`"pretty`": `"eslint --debug src/**/*.js --fix`"`n},`n`"repository`": {`n`"type`": `"git`",`n`"url`": `"git+https://github.com/FireInjun/$projectName.git`"`n},`n`"keywords`": [],`n`"author`": `"FireInjun`",`n`"license`": `"MIT`",`n`"bugs`": {`n`"url`": `"https://github.com/FireInjun/$projectName/issues`"`n},`n`"homepage`": `"https://github.com/FireInjun/$projectName#readme`"`n}"
  dependencies = @("@babel/core", "@babel/preset-env", "@babel/preset-react", "babel-eslint", "babel-jest", "babel-loader", "babel-plugin-styled-components", "css-loader", "enzyme", "enzyme-adapter-react-16", "enzyme-to-json", "eslint", "eslint-config-airbnb", "eslint-config-jest-enzyme", "eslint-config-prettier", "eslint-plugin-babel", "eslint-plugin-import", "eslint-plugin-jest", "eslint-plugin-jsx-a11y", "eslint-plugin-prettier", "eslint-plugin-react", "html-loader", "html-webpack-plugin", "husky", "jest", "jest-styled-components", "lint-staged", "prettier", "react", "react-dom", "style-loader", "styled-components", "stylelint", "stylelint-config-recommended", "stylelint-config-styled-components", "stylelint-processor-styled-components", "stylelint-webpack-plugin", "webpack", "webpack-cli", "webpack-dev-server")
}

$boilerplate = [ordered]@{
  dirs  = @("src", "src/__tests__", "src/style")
  files = [ordered]@{
    appjs      = @( "App.js", "import React from 'react';`n`nconst App = () => {`n  return <div>Hello React, Webpack 4 & Babel 7!</div>;`n};`nexport default App;", "src/App.js")    
    appunit    = @( "App.test.js", "import React from 'react';`nimport ReactDOM from 'react-dom';`nimport App from './App';`n`nit('renders without crashing', () = > {`n    const div = document.createElement('div');`n    ReactDOM.render(<App />, div);`n    ReactDOM.unmountComponentAtNode(div);`n  });`n", "src/App.test.js")    
    indexjs    = @( "index.js", "import React from 'react';`nimport ReactDOM from 'react-dom';`nimport App from './App';`n`nReactDOM.render(<App />, document.getElementById('root'));`n", "src/index.js")    
    indexhtml  = @( "index.html", "<!DOCTYPE html>`n<html lang=`"en`">`n`n<!--[if lt IE 7]>      <html class=`"no-js lt-ie9 lt-ie8 lt-ie7`"> <![endif]-->`n<!--[if IE 7]>         <html class=`"no-js lt-ie9 lt-ie8`"> <![endif]-->`n<!--[if IE 8]>         <html class=`"no-js lt-ie9`"> <![endif]-->`n<!--[if gt IE 8]><!--> <html class=`"no-js`"> <!--<![endif]-->`n<head>`n<meta charset=`"utf-8`">`n<meta http-equiv=`"X-UA-Compatible`" content=`"IE=edge`">`n<title>React From Scratch!</title>`n<meta name=`"description`" content=`"`">`n<meta name=`"viewport`" content=`"width=device-width, initial-scale=1`">`n</head>`n<body>`n<div id=`"root`"></div>`n</body>`n</html>", "src/index.html")    
    appstyle   = @( "App.style.js", "//styled-components", "src/App.style.js")    
    indexstyle = @( "index.style.js", "//styled-components", "src/index.style.js")    
    appintest  = @( "App.spec.js", "import React from 'react';`nimport ReactDOM from 'react-dom';`nimport App from '../src/App';`n`nit('renders without crashing', () = > {`n    const div = document.createElement('div');`n    ReactDOM.render(<App />, div);`n    ReactDOM.unmountComponentAtNode(div);`n  });`n", "src/__tests__/App.spec.js")
  }
}
function Use-NetworkConnection {
  <#
  .SYNOPSIS
    Use internet or not
  .DESCRIPTION
    Decides whether to use Internet or not. You can't use what you don't have?! So this is more of a tests runner f(x).
  #>
  [CmdletBinding()]
  param (
    # The host/domain name you want to test
    [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
    [String]$HostName = "google.com",
    # Count
    [Parameter(Mandatory = $false)]
    [int]$Count = 1
  )
  
  begin {
    $ErrorActionPreference = "SilentlyContinue"
  }
  
  process {
    [string]$status = "not connected"
    Write-Verbose "Testing network connection ..."
    if (Test-Connection -ComputerName $HostName -Quiet -Count $Count) {
      Write-Verbose "You're connected!"
      return $true
    }
    else {
      # log some shit ex: $_.Exception.message
      # something like: No internet Connection because [System.Net.NetworkInformation.PingException]
      Write-Verbose "You're $status!"
      return $false
    }
  }
  
  end {
    $ErrorActionPreference = "Continue"
  }
}
function Initialize-Project {
  for ($i = 0; $i -lt $boilerplate.dirs.Count; $i += 1) {
    Write-Host "Creating" -NoNewline -ForegroundColor Cyan; Write-Host " $($boilerplate.dirs[$i])" -NoNewline -ForegroundColor Yellow; Write-Host "..." -NoNewline
    New-Item -Path . -Name $boilerplate.dirs[$i] -ItemType "directory" | Out-Null
    Write-Host "Done" -ForegroundColor Green;
  }
}
function Write-Projectfiles {
  for ($i = 0; $i -lt $boilerplate.files.Count; $i += 1) {
    New-Item -Path $boilerplate.files[$i][2]  -ItemType "file" -Value $boilerplate.files[$i][1] | Out-Null
  }
}
function Update-ConfigFiles {
  Write-Host "Write" -NoNewline -ForegroundColor Cyan; Write-Host " Project files" -NoNewline -ForegroundColor Yellow; Write-Host "..." -NoNewline
  for ($i = 0; $i -lt $configfiles.Count; $i += 1) {
    New-Item -Path . -Name $configfiles[$i][0] -ItemType "file" -Value $configfiles[$i][1] | Out-Null
  }
  Write-Host "Done" -ForegroundColor Green;
}
function Install-dependencies {
  Write-Host "Installing" -NoNewline -ForegroundColor Cyan; Write-Host " Dependencies" -NoNewline -ForegroundColor Yellow; Write-Host "..."
  New-Item -Path . -Name $npmpack[0] -ItemType "file" -Value $npmpack[1] | Out-Null
  if (Use-NetworkConnection) {
    for ($i = 0; $i -lt $npmpack.dependencies.Count; $i += 1) { 
      npm install $npmpack.dependencies[$i] 
    }
  }
  else {
    Write-Warning "Still No network connection available !"
    ""
    Write-Host "Find some internet godam!t" -ForegroundColor Red;
    Pop-Location; Remove-Item -Recurse -Force $projectName | Out-Null
    break script
    # Exit-PSSession
  }
  Write-Host "Done" -ForegroundColor Green;
}
function main {
  if ((Test-Path $projectName) -and !$Force) {
    Write-Host "The folder $projectName already Exists. " -NoNewline -ForegroundColor Yellow ;
    do {
      [string]$str = $((New-Guid).Guid.trim()).ToLowerInvariant()
      $projectName = "$('My-React-app_'+ $(Get-Date -DisplayHint Date).ToString().Replace('/','-').Replace(' ','_').Replace(':','.') + $str)";
    } while (Test-Path $projectName)
    mkdir $projectName | Out-Null
  }
  elseif ((Test-Path $projectName) -and $Force) {
    Remove-Item -Recurse -Force $projectName | Out-Null
    mkdir $projectName | Out-Null
  }
  else {
    mkdir $projectName | Out-Null
  }
  $projectName = $((Get-Item $projectName).FullName)
  Write-Output "$projectName"
  Push-Location $projectName; Write-Host "Using: " -NoNewline -ForegroundColor Cyan ; "'$(Get-Location)'"
  if (!$(Use-NetworkConnection)) { Write-Warning "No network connection available !" ; "" }
  Initialize-Project
  Write-Projectfiles
  Update-ConfigFiles
  Install-dependencies
  Pop-Location
  # and ... maybe say congratulations!
}
main