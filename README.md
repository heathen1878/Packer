# Packer

## Examples

Build an image using the Packer configuration found in ./buildagent/managed_image/WIndows and supply additional values using ./builds/windows.pkrvars.hcl.

```packer
packer build -var-file="builds/windows.pkrvars.hcl" -var use_interactive_auth=true -var subscription_id="00000000-0000-0000-0000-000000000000" 'buildagent/managed_image/Windows'
```
