function Get-MarkdownDescription {

    param($obj,$type)

    if($type -eq "Module"){
        $description = $obj.Description.replace("  ",'') + "`n"
    }elseif($type -eq "Function"){

        #tbd

    }

    return $description

}