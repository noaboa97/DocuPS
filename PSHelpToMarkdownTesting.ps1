
$syntax = $function.name

foreach($param in $parameters){

    $name = $param.name
    $paramvalue = $param.parametervalue

    $mand = $param.required

    $position = $param.position

    if($mand -and $position -ne "named"){
        $syntax += " [-$name] <$paramvalue>`n"
    }elseif($mand -and $position -eq "named"){
        $syntax += " -$name <$paramvalue>`n"
    }elseif(-not $mand -and $position -eq "named"){
        $syntax += " [-$name <$paramvalue>]`n"
    }elseif(-not $mand -and $position -ne "named"){
        # not mandatory
        $syntax += " [[-$name] <$paramvalue>]`n"
    }

}