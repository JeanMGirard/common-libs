# SSM Port forward

```bash
alias awsv-exec='aws-vault exec ${AWS_PROFILE:-default} -- aws'

INSTANCE_ID=$(awsv-exec ec2 describe-instances \
  --filters 'Name=tag:Name,Values=gtv-*-spark-master' \
  --query 'Reservations[0].Instances[0].InstanceId' \
  --output text | tr -d '\n')
PORT='18080' # Spark (18080) RDS (3306)
PORT_LOCAL=

## Spark UI ======================================================================
awsv-exec ssm start-session \
  --target  $INSTANCE_ID \
  --document-name AWS-StartPortForwardingSession \
  --parameters "{\"portNumber\":[\"$PORT\"], \"localPortNumber\":[\"${PORT_LOCAL:-$PORT}\"]}"

## RDS ===========================================================================
PORT='3306' # Spark (18080) RDS (3306)
FORWARD_TO=$(awsv-exec rds describe-db-instances \
  --query "DBInstances[?starts_with(DBInstanceIdentifier, 'gtv-') && contains(DBInstanceIdentifier, 'database')]| \
  [0].Endpoint.Address" \
  --output text | tr -d '\n')


awsv-exec ssm start-session \
  --target  i-090364c89d5a209bd \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"$FORWARD_TO\"],\"portNumber\":[\"$PORT\"], \"localPortNumber\":[\"${PORT_LOCAL:-$PORT}\"]}"
# ================================================================================

```
