$module = get-module XMCmdlets

$path = "U:\Readme.md"

New-Item -Path $path -force | out-null

# Get Synopsis of Module (from PSM File - Title of the Readme will be Text form Synopsis)
$reg = [regex]::new('.SYNOPSIS[\r\n]+([^\r\n]+)') 
$m = $reg.Match($module.definition)
$modulesynopsis = "# " + ($m.groups[1].value).TrimStart() + "`n"

Add-Content -Path $path -Value $modulesynopsis

# Get Description of Module (from PSM File - Description of the Readme will be Text form Synopsis Description)
$moduledescription = $module.Description.replace("  ",'') + "`n"

Add-Content -Path $path -Value $moduledescription

Add-Content -Path $path -Value "## Functions"
Add-Content -Path $path -Value "Currently it provides the following functions"
Add-Content -Path $path -Value "| Function  | Description   | Type   |"
Add-Content -Path $path -Value "| ------------- | ------------- |:------:|"

$cmdlets = $module.ExportedCommands

foreach($function in $cmdlets.Values){

    $name = $function.name
    $help = Get-Help $function.name

    Add-Content -Path $path -Value "| $($name) | $($help.synopsis) | PowerShell $($help.category) |"
    #Write-Host "| $($function.values) | $((Get-Help $function.values).synopsis) | PowerShell $((Get-Help get-xmctoken).category) |"

    
}

foreach($function in $cmdlets.values){

    $func = Get-Help $function.name
    #$syntax = ($func.syntax | out-string).Trim()

    $examplesobj = $func.examples

    $examples = $null

    foreach($examp in $examplesobj.example){
        $code = $examp.code
        $remarks = $examp.remarks.text

        $examples += $code + "`n" + $remarks + "`n"

    }

    $parameters = $func.syntax.syntaxItem.parameter 

    $syntax = $function.name + "`n"
    
    foreach($param in $parameters){
    
        $name = $param.name
        $paramvalue = $param.parametervalue
    
        $mand = $param.required
    
        $position = $param.position
    
        if($mand -and $position -ne "named"){
            $syntax += "   [-$name] <$paramvalue>`n"
        }elseif($mand -and $position -eq "named"){
            $syntax += "   -$name <$paramvalue>`n"
        }elseif(-not $mand -and $position -eq "named"){
            $syntax += "   [-$name <$paramvalue>]`n"
        }elseif(-not $mand -and $position -ne "named"){
            # not mandatory
            $syntax += "   [[-$name] <$paramvalue>]`n"
        }
    
    }

    Add-Content -Path $path -Value "### $($func.name)"
    Add-Content -Path $path -Value "#### SYNTAX"
    Add-Content -Path $path -Value '``` powershell'
    Add-Content -Path $path -Value "$($syntax.trim())"
    Add-Content -Path $path -Value '```'

    Add-Content -Path $path -Value '``` powershell'
    Add-Content -Path $path -Value "$($examples.trim())"
    Add-Content -Path $path -Value '```'

}











