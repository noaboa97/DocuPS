function Get-MarkdownH1 {

    param($obj,$type)

    if($type -eq "Module"){
        $reg = [regex]::new('.SYNOPSIS[\r\n]+([^\r\n]+)') 
        $m = $reg.Match($obj.definition)
        $title = "# " + ($m.groups[1].value).TrimStart() + "`n"
    }elseif($type -eq "Function"){

        #tbd

    }

    return $title

}
