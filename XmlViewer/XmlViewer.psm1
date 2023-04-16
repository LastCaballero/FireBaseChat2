Add-Type -AssemblyName PresentationFramework


Function Show-Xaml {
    param(
        $file
    )
    $XAML = [System.Windows.Markup.XamlReader]::Parse(((Get-Content $file) -replace 'x:Class=".*MainWindow"',"" -replace 'Click=".*"',""))
    $XAML.ShowDialog()
}
