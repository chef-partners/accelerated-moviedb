Configuration "movieapp_com"
{
    Import-DscResource -Module xWebAdministration
    Node 'localhost' {

	    WindowsFeature "Web-Asp-Net"
        {
            Ensure = "Present"
            Name = "Web-Asp-Net"
        }

        xWebAppPool "movieapp.com_apppool"
        {
            Name   = "movieapp.com_apppool"
            ManagedPipelineMode = "Integrated"
            ManagedRuntimeVersion = "v2.0"
            Ensure = "Present"
            State  = "Started"
        }

        xWebsite "movieapp.com"
        {
            Ensure          = "Present"
            Name            = "movieapp.com"
            ApplicationPool = "movieapp.com_apppool"
            State           = "Started"
            PhysicalPath    = Resolve-Path "{{pkg.svc_path}}/publish"
            BindingInfo = @(
                MSFT_xWebBindingInformation
                {
                    Protocol = "http"
                    Port = {{cfg.site.http_port}}
                }
            )
        }
        
    }
}