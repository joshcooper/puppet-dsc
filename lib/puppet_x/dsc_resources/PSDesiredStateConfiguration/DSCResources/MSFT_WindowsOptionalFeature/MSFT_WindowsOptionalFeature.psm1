# This PS module contains functions for Desired State Configuration Windows Optional Feature provider. It enables configuring optional features on Windows Client SKUs.

# Fallback message strings in en-US
DATA localizedData
{
    # culture = "en-US"
    ConvertFrom-StringData @'                
        DismNotAvailable = PowerShell module Dism could not be imported.
        NotAClientSku = This Resource is only available for Windows Client.
        ElevationRequired = This Resource requires to be run as an Administrator.
        ValidatingPrerequisites = Validating prerequisites...
        CouldNotCovertFeatureState = Could not convert feature state '{0}' into Enable/Disable.
        EnsureNotSupported = The value '{0}' for property Ensure is not supported.
        RestartNeeded = Target machine needs to be restarted.
        GetTargetResourceStartMessage = Begin executing Get functionality on the {0} feature.
        GetTargetResourceEndMessage = End executing Get functionality on the {0} feature.
        SetTargetResourceStartMessage = Begin executing Set functionality on the {0} feature.
        SetTargetResourceEndMessage = End executing Set functionality on the {0} feature.
        TestTargetResourceStartMessage = Begin executing Test functionality on the {0} feature.
        TestTargetResourceEndMessage = End executing Test functionality on the {0} feature.
        FeatureInstalled = Installed feature {0}.
        FeatureUninstalled = Uninstalled feature {0}.
'@
}
Import-LocalizedData LocalizedData -filename MSFT_WindowsOptionalFeature.strings.psd1


function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name
	)

    Write-Debug ($LocalizedData.GetTargetResourceStartMessage -f $Name)

    ValidatePrerequisites

    $result = Dism\Get-WindowsOptionalFeature -FeatureName $Name -Online -Verbose:$false

	$returnValue = @{
		LogPath = $result.LogPath
		Ensure = ConvertStateToEnsure $result.State
		CustomProperties = SerializeCustomProperties $result.CustomProperties
		Name = $result.FeatureName
		LogLevel = $result.LogLevel
		Description = $result.Description
		DisplayName = $result.DisplayName
	}

	$returnValue

    Write-Debug ($LocalizedData.GetTargetResourceEndMessage -f $Name)
}

# Serializes a list of CustomProperty objects into [System.String[]]
function SerializeCustomProperties
{
    param
    (
        $CustomProperties
    )

    $CustomProperties | ? {$_ -ne $null} | % { "Name = $($_.Name), Value = $($_.Value), Path = $($_.Path)" }
}

# Converts state returned by Dism Get-WindowsOptionalFeature cmdlet to Enable/Disable
function ConvertStateToEnsure
{
    param
    (
        $State
    )

    if ($state -eq 'Disabled')
    {
        'Disable'
    }
    elseif ($state -eq 'Enabled')
    {
        'Enable'
    }
    else
    {
        Write-Warning ($LocalizedData.CouldNotCovertFeatureState -f $state)
        $state
    }
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[System.String[]]
		$Source,

		[System.Boolean]
		$RemoveFilesOnDisable,

		[System.String]
		$LogPath,

        [parameter(Mandatory = $true)]
		[ValidateSet("Enable","Disable")]
		[System.String]
		$Ensure,

		[System.Boolean]
		$NoWindowsUpdateCheck,

		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[ValidateSet("ErrorsOnly","ErrorsAndWarning","ErrorsAndWarningAndInformation")]
		[System.String]
		$LogLevel
	)

    Write-Debug ($LocalizedData.SetTargetResourceStartMessage -f $Name)

    ValidatePrerequisites

    switch ($LogLevel)
    {
        'ErrorsOnly' { $DismLogLevel = 'Errors' }
        'ErrorsAndWarning' { $DismLogLevel = 'Warnings' }
        'ErrorsAndWarningAndInformation' { $DismLogLevel = 'WarningsInfo' }
        '' { $DismLogLevel = 'WarningsInfo' }
    }

    # construct parameters for Dism cmdlets
    $PSBoundParameters.Remove('Name') > $null
    $PSBoundParameters.Remove('Ensure') > $null
    if ($PSBoundParameters.ContainsKey('RemoveFilesOnDisable'))
    {
        $PSBoundParameters.Remove('RemoveFilesOnDisable')
    }

    if ($PSBoundParameters.ContainsKey('NoWindowsUpdateCheck'))
    {
        $PSBoundParameters.Remove('NoWindowsUpdateCheck')
    }

    if ($PSBoundParameters.ContainsKey('LogLevel'))
    {
        $PSBoundParameters.Remove('LogLevel')
    }

    if ($PSBoundParameters.ContainsKey('Verbose'))
    {
        $PSBoundParameters.Remove('Verbose')
    }
    
    if ($Ensure -eq 'Enable')
    {
        if ($NoWindowsUpdateCheck)
        {
            $feature = Dism\Enable-WindowsOptionalFeature -FeatureName $Name -Online -LogLevel $DismLogLevel @PSBoundParameters -LimitAccess -NoRestart -Verbose:$false
        }
        else
        {
            $feature = Dism\Enable-WindowsOptionalFeature -FeatureName $Name -Online -LogLevel $DismLogLevel @PSBoundParameters -NoRestart -Verbose:$false
        }

        Write-Verbose ($LocalizedData.FeatureInstalled -f $Name)
    }
    elseif ($Ensure -eq 'Disable')
    {
        if ($RemoveFilesOnDisable)
        {
            $feature = Dism\Disable-WindowsOptionalFeature -FeatureName $Name -Online -LogLevel $DismLogLevel @PSBoundParameters -Remove -NoRestart -Verbose:$false
        }
        else
        {
            $feature = Dism\Disable-WindowsOptionalFeature -FeatureName $Name -Online -LogLevel $DismLogLevel @PSBoundParameters -NoRestart -Verbose:$false
        }

        Write-Verbose ($LocalizedData.FeatureUninstalled -f $Name)
    }
    else
    {
        throw ($LocalizedData.EnsureNotSupported -f $Ensure)
    }

    if ($feature.RestartNeeded)
    {
        Write-Verbose $LocalizedData.RestartNeeded
        $global:DSCMachineStatus = 1
    }

    Write-Debug ($LocalizedData.SetTargetResourceEndMessage -f $Name)
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[System.String[]]
		$Source,

		[System.Boolean]
		$RemoveFilesOnDisable,

		[System.String]
		$LogPath,

		[ValidateSet("Enable","Disable")]
		[System.String]
		$Ensure,

		[System.Boolean]
		$NoWindowsUpdateCheck,

		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[ValidateSet("ErrorsOnly","ErrorsAndWarning","ErrorsAndWarningAndInformation")]
		[System.String]
		$LogLevel
	)

    Write-Debug ($LocalizedData.TestTargetResourceStartMessage -f $Name)

    ValidatePrerequisites

    $result = Dism\Get-WindowsOptionalFeature -FeatureName $Name -Online -Verbose:$false

    if ($result -eq $null)
    {
        $result = 'Disabled'
    }

    if (($result.State -eq 'Disabled' -and $Ensure -eq 'Disable')`
        -or ($result.State -eq 'Enabled' -and $Ensure -eq 'Enable'))
    {
        $true
    }
    else
    {
        $false
    }

    Write-Debug ($LocalizedData.TestTargetResourceEndMessage -f $Name)
}

# ValidatePrerequisites is a helper function used to validate if the MSFT_WindowsOptionalFeature is supported on the target machine.
function ValidatePrerequisites   
{
    Write-Verbose $LocalizedData.ValidatingPrerequisites

    # check that we're running on a client SKU
    $os = Get-CimInstance -ClassName  Win32_OperatingSystem -Verbose:$false
    
    if ($os.ProductType -ne 1)
    {
        throw $LocalizedData.NotAClientSku
    }

    # check that we are running elevated
    $windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $windowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($windowsIdentity)
    $adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

    if (!$windowsPrincipal.IsInRole($adminRole))
    {
        throw $LocalizedData.ElevationRequired
    }

    # check that Dism PowerShell module is available
    Import-Module Dism -Force -ErrorVariable ev -ErrorAction SilentlyContinue -Verbose:$false

    if ($ev.Count -gt 0)
    {
        throw $LocalizedData.DismNotAvailable
    }
}


Export-ModuleMember -Function *-TargetResource

