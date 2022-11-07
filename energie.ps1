using namespace System.Windows.Forms
using namespace System.Drawing

class MyButton : Button {
    $Action
    MyButton($text, $action){
        $this.Text = $text
        $this.Action = $action
        $this.Height = 170
        $this.Width = 200
        }
    [void]OnClick([System.EventArgs] $e ){
        Invoke-Expression $this.Action
    }


}

class MyForm : Form {
    [MyButton]$save
    [MyButton]$balanced
    [MyButton]$power
    [FlowLayoutPanel]$layout
    MyForm() {
        $this.Width = 600
        $this.Height = 200
        $this.save =[MyButton]::new("Save", "powercfg /setactive scheme_max" )
        $this.balanced = [MyButton]::new("Balanced", "powercfg /setactive scheme_balanced" )
        $this.power = [MyButton]::new("Power", "powercfg /setactive scheme_min" )
        $this.ArrangeButtons()
        $this.Controls.AddRange( @( $this.save, $this.balanced, $this.power ) )
    }
    [void]ArrangeButtons() {
        $this.save.Location = [Point]::new(0,0 )
        $this.balanced.Location = [Point]::new(200,0 )
        $this.power.Location = [Point]::new(400,0 )
    }
}

$form = [MyForm]::new()
$form.ShowDialog()

