Configuration "MovieApp"
{
    Import-DscResource -Module xWebAdministration
    Node 'localhost' {
        xWebAppPool "DefaultAppPool"
        {
            Name   = "DefaultAppPool"
            ManagedPipelineMode = "Integrated"
            ManagedRuntimeVersion = "v4.0"
            Ensure = "Present"
            State  = "Started"
        }

        xWebsite "movie-database"
        {
            Ensure          = "Present"
            Name            = "movie-database"
            State           = "Started"
            PhysicalPath    = "C:\MovieApp\package"
            BindingInfo = @(
                MSFT_xWebBindingInformation
                {
                    Protocol = "http"
                    Port = {{cfg.port}}
                }
            )
        }

        xWebApplication "MovieApp"
        {
            Name = "MovieApp"
            Website = "movie-database"
            WebAppPool =  "DefaultAppPool"
            PhysicalPath = "C:\MovieApp\package"
            Ensure = "Present"
        }
    }
}