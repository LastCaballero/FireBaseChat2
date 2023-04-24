

function Compile-Csharp {
    param(
        [string]$FileName
    )
    $FileToCompile = Get-Item $FileName
    $CodeProvider = [Microsoft.CSharp.CSharpCodeProvider]::new()
    $Compiler = $CodeProvider.CreateCompiler()
    $CompilerOptions = [System.CodeDom.Compiler.CompilerParameters]::new()
    $CompilerOptions.GenerateExecutable = $true
    $Compiler.CompileAssemblyFromFile( $CompilerOptions, $FileToCompile )
}
