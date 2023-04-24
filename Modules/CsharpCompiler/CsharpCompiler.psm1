

function Compile-Csharp {
    param(
        [string]$FileName,
        [string]$ExeName
    )
    $FileToCompile = Get-Item $FileName
    $CodeProvider = [Microsoft.CSharp.CSharpCodeProvider]::new()
    $Compiler = $CodeProvider.CreateCompiler()
    $CompilerOptions = [System.CodeDom.Compiler.CompilerParameters]::new()
    $CompilerOptions.GenerateExecutable = $true
    $CompilerOptions.OutputAssembly = $PWD + "\" + $ExeName
    $Compiler.CompileAssemblyFromFile( $CompilerOptions, $FileToCompile )
}
