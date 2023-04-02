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

        $value += "`n| $($name) | $($help.synopsis) | PowerShell $($help.category) |"
                
    }

return $value

}