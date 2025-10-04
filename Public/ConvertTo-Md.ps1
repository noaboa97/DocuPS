function ConvertTo-Md {

    <#
    .SYNOPSIS
    Converts PowerShell help into a Markdown file
    .DESCRIPTION
    Converts PowerShell help into a Markdown file for a whole module or just a few functions

    .PARAMETER ModuleName
    Module for which the Markdown file should be generated. Module needs to be properly documentent with a synopsis.

    .PARAMETER FunctionPath
    Path to the function if you want to document a function

    .PARAMETER FileName
    Name of the file to output

    .PARAMETER Type
    Type of what you want to create the markdown file from
    
    .OUTPUTS
    .md File

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  27.07.2022
    Purpose/Change: Initial function development
  
    .EXAMPLE
    ConvertTo-Md -ModuleName XMCmdlets -Type Module

    .EXAMPLE
    ConvertTo-Md -type Function -FunctionPath Get-XMCToken
    #>

    [CmdletBinding()]
    param (
        [Parameter(valuefrompipeline = $true,
            mandatory = $true,
            ParameterSetName = 'Module',
            HelpMessage = "Enter the name of the module")]
        [string]
        $ModuleName,

        [Parameter(valuefrompipeline = $true,
            mandatory = $true,
            ParameterSetName = 'Function',
            HelpMessage = "Enter path of the function file")]
        [string]
        $FunctionPath,

        [Parameter(ParameterSetName = 'Function')]
        [Parameter(valuefrompipeline = $true,
            ParameterSetName = 'Module',
            HelpMessage = "Enter the name of the file")]
        [string]
        $FileName = "Readme.md",

        [Parameter(ParameterSetName = 'Module')]
        [Parameter(ParameterSetName = 'Function')]
        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter what type you want to document")]
        [ValidateSet("Module", "Function")]
        $Type
    )

    begin{
        New-Item -Path $FileName -force | out-null
    }


    process{

        if ($Type -eq "Module") {
            $module = get-module $ModuleName

            if($null -eq $module){

                try{

                    Import-Module $ModuleName
                    $module = get-module $ModuleName

                }catch{

                    throw "Error importing module"

                }

            }

            # Get the Synopsis from the PSM 
            $title = Get-MarkdownH1 $module $type
            
            # Get the Synopsis description from the PSM
            $description = Get-MarkdownDescription $module $Type

            $functiontable = New-MarkdownFunctionTable $module

            $Functions = New-MarkdownFunction $module

            Add-Content -Path $filename -Value "$title `n $description `n $functiontable `n $functions"

        }
        elseif ($Type -eq "Function") {
           # To do
        }

    }

}