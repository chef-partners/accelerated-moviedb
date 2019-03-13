# Example InSpec Profile For IIS Web Application MovieApp

Automatically generated InSpec profile for MovieApp.

## Update `attributes.yml` to point to your deployed instance of MovieApp 

```
iis_app_url: 'http://127.0.0.1/MovieApp'
```

## Run the tests

```
$ inspec exec inspec-profile --attrs attributes.yml

```