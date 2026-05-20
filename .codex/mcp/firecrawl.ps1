$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir '..\..')
$envPath = Join-Path $repoRoot '.env'

if (-not (Test-Path $envPath)) {
  Write-Host 'FIRECRAWL_API_KEY missing'
  exit 1
}

$match = Select-String -Path $envPath -Pattern '^\s*FIRECRAWL_API_KEY\s*=\s*(.+?)\s*$' | Select-Object -First 1
$firecrawlKey = $null
if ($match) {
  $firecrawlKey = $match.Matches[0].Groups[1].Value.Trim()
  if ($firecrawlKey.StartsWith('"') -and $firecrawlKey.EndsWith('"')) {
    $firecrawlKey = $firecrawlKey.Trim('"')
  }
  elseif ($firecrawlKey.StartsWith("'") -and $firecrawlKey.EndsWith("'")) {
    $firecrawlKey = $firecrawlKey.Trim("'")
  }
}

if ([string]::IsNullOrWhiteSpace($firecrawlKey)) {
  Write-Host 'FIRECRAWL_API_KEY missing'
  exit 1
}

$env:FIRECRAWL_API_KEY = $firecrawlKey
& npx -y firecrawl-mcp
