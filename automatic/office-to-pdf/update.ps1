﻿import-module au

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $github_repository = 'cognidox/OfficeToPDF'
    $releases = 'https://github.com/' + $github_repository + '/releases/latest'    
    $regex = '/cognidox/OfficeToPDF/tree/v(?<Version>[\d\.]+)'
	$url = (Invoke-WebRequest -Uri $releases -UseBasicParsing).links | ? href -match $regex | Select -First 1
    $version = $matches.Version

	return @{
        Version = $version
        URL32 = 'https://github.com/cognidox/OfficeToPDF/releases/download/v' + $version + '/OfficeToPDF.exe' }    
}

function global:au_SearchReplace {
    @{
        "legal\VERIFICATION.txt"  = @{
            "(?i)(x32: ).*"             = "`${1}$($Latest.URL32)"
            "(?i)(x64: ).*"             = "`${1}$($Latest.URL32)"
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType32)"
            "(?i)(checksum32:).*"       = "`${1} $($Latest.Checksum32)"
            "(?i)(checksum64:).*"       = "`${1} $($Latest.Checksum32)"
        }        
    }
}

update -ChecksumFor none