function New-MarkdownFunctionTable{
    
    param($module)

    $value = @'
## Functions
Currently it provides the following functions
| Function  | Description   | Type   |
| ------------- | ------------- |:------:|
'@

$cmdlets = $module.ExportedCommands

    foreach($function in $cmdlets.Values){

        $name = $function.name
        $help = Get-Help $function.name


        $trimmedsynopsis = $($help.synopsis.replace("`r`n"," ").trim())

        $value += "`n| $($name) | $(if($trimmedsynopsis -eq $name){" "}else{$($help.Synopsis.trim())}) | PowerShell $($help.category) |"
                
    }

return $value

}