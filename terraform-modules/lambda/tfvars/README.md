# TFVars with ReleaseHub Infrastructure Runner

One example strategy is to have a `default.tfvars` that is in your Application Template and used for newly-created environments.

Then, users can switch to different configurations for ephemeral environments, e.g. `load_test.tfvar`, where needed.
