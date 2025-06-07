# AWS

https://jmespath.org/specification.html#built-in-functions

```shell

function awsv-login(){
  PROFILE=; ASSUME_ROLE=; OPEN=;

  for arg in "$@" ; do
    case "${arg}" in
        -o | --open) OPEN=yes;;
        -e | --assume) ASSUME_ROLE=yes;OPEN="${OPEN:-no}";;
        -h | --help) 
          echo -e "\n  awsv-login [profile] [--open|-o] [--assume|-e]"; 
          echo -e "  awsv-login profiles  \n"; 
          echo -e "  awsv-login logout  \n"; 
          return;;
        profiles) aws-vault list; return;;
        logout) eval  "unset `echo $(env | grep -P '^AWS_(ACCESS|SECRET|SESSION|SECURITY)' | cut -d '=' -f1)`";;
        *) PROFILE=${OPTARG};;
    esac
  done

  if [ -z "$PROFILE" ]; then PROFILE="${AWS_PROFILE:-default}"; fi
  if [ "$ASSUME_ROLE" == "yes" ]; then
    echo "assuming role $PROFILE"
    # export AWS_PROFILE="$PROFILE"
    eval "$(aws-vault exec $PROFILE -- env | grep -P '^AWS_(ACCESS|SECRET|SESSION|SECURITY)' | sed 's/^/export /' )" 
  fi
  if [ "${OPEN:-yes}" == "yes" ]; then aws-vault login "$PROFILE"; fi
}

alias awsv='aws-vault'
alias awsv-exec='aws-vault exec ${AWS_PROFILE:-default} -- aws'
alias aws-login='awsv-login'
alias aws-logout='unset AWS_VAULT AWS_DEFAULT_REGION AWS_REGION AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN AWS_SESSION_EXPIRATION'
alias aws-profiles='aws-vault list'
alias aws-exec='aws-tools exec'
alias aws-scp='aws-tools scp'
alias aws-ssh='aws-tools ssh'
alias aws-tunnel='aws-tools tunnel'
```

## STS

### assume-role

```shell

ROLE_ARN="arn:aws:sts::248048817139:role/gaas-superuser"
ROLE_ARN="arn:aws:sts::658784467646:role/gaas-superuser"
ROLE_ARN="arn:aws:iam::269449123021:role/tks-glbsec-superuser"
SESSION=$(awsv-exec sts assume-role --role-session-name test --role-arn $ROLE_ARN)

export AWS_ACCESS_KEY_ID=$(echo "$SESSION" | jq .Credentials.AccessKeyId |  sed -En "s/\"(.*)\"/\1/p")
export AWS_SECRET_ACCESS_KEY=$(echo "$SESSION" | jq .Credentials.SecretAccessKey |  sed -En "s/\"(.*)\"/\1/p")
export AWS_SESSION_TOKEN=$(echo "$SESSION" | jq .Credentials.SessionToken |  sed -En "s/\"(.*)\"/\1/p")

aws sts get-caller-identity
```

-backend-config="access_key=<your access key>" -backend-config="secret_key=<your secret key>"

```shell
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
```

### 

aws-vault exec gtv-uat-superuser -- aws ec2 describe-instances --output text | tee "uat.txt"

--query "Reservations[*].Instances[*].{Id:InstanceId,Type:InstanceType,Name:Tags[?Key=='Name']|[0].Value}"
--filters Name=instance-type,Values=M5.large

--query "Reservations[*].Instances[*].[InstanceId,{Type:InstanceType,Name:Tags[?Key=='Name']|[0].Value}]"
.[InstanceId]

aws-vault exec gtv-uat-superuser -- aws ec2 describe-instances --output text | tee "uat.txt"

## Powershell

```powershell
Import-Module -Name AWS.Tools.Common

# Set-AWSCredentials -AccessKey XXXXXXXXXXXXXXXX -SecretKey XXXXXXX -StoreAs Ticksmith
# Initialize-AWSDefaults -ProfileName Ticksmith -Region us-east-1

Set-AWSCredential -ProfileName Ticksmith
$ROLE_ARN="arn:aws:sts::248048817139:role/gaas-superuser"
$Creds = (Use-STSRole -ProfileName Ticksmith -RoleArn $ROLE_ARN -RoleSessionName "jean.girard").Credentials


Remove-Variable Env:AWS_PROFILE
[Environment]::SetEnvironmentVariable("AWS_PROFILE", $null ,"User") 

$Env:AWS_ACCESS_KEY_ID=$Creds.AccessKeyId
$Env:AWS_SECRET_ACCESS_KEY=$Creds.SecretAccessKey
$Env:AWS_SESSION_TOKEN=$Creds.SessionToken
```
