function New-MarkdownFunction{

    param($module)

$cmdlets = $module.ExportedCommands

foreach($function in $cmdlets.values){

    $func = Get-Help $function.name

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
    
        $mand = [System.Convert]::ToBoolean($param.required)
    
        $position = $param.position
    
        if([bool]$mand -and $position -ne "named"){
            $syntax += "   [-$name] <$paramvalue>`n"
        }elseif([bool]$mand -and $position -eq "named"){
            $syntax += "   -$name <$paramvalue>`n"
        }elseif(-not $mand -and $position -eq "named"){
            $syntax += "   [-$name <$paramvalue>]`n"
        }elseif(-not $mand -and $position -ne "named"){
            # not mandatory
            $syntax += "   [[-$name] <$paramvalue>]`n"
        }
    
    }

    $value += @'

### {0}
#### SYNTAX
``` powershell
{1}
```

#### Examples

``` powershell
{2}
```

'@ -f $func.name, $syntax.trim(), $examples.trim()

    #$value
    }

    return $value
}