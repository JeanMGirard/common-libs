#!/usr/bin/env bash

ROOT_DIR="$(git rev-parse --show-toplevel)";


cat << EOF
---
image: dtzar/charts-kubectl
include:
  - local: ${CHARTS_CI_SRC}

stages:
  - test
  - install
  - release

EOF
# Dont replace variables
cat << 'EOF'

.lint:chart:
	extends: [.chart]
  script:
    - 'charts lint ${CHART_NAME}'

.release:chart:
	extends: [.chart]
  before_script:
    - 'apk add --no-cache git'
    - 'charts plugin install https://github.com/chartmuseum/charts-push'
    - 'charts repo add --username gitlab-ci-token --password ${CI_JOB_TOKEN} ${HELM_PROJECT} ${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/charts/stable'
  script:
    - 'charts package ${CHART_NAME}'
    - 'charts cm-push ${CHART_NAME} ${HELM_PROJECT}'

# ==================================================================
# CHARTS WILL BE GENERATED BELOW
# ==================================================================
EOF


for d in $(find "$ROOT_DIR/charts/"* -maxdepth 0 -type d); do
	[[ ! -f "$d/Chart.yaml" ]] && continue;

	CHART_NAME=$(basename $d)
  CHART_VERSION=$(grep "^version:" "${d}/Chart.yaml" | cut -d' ' -f2-)
  CHART_RELEASE="${CHART_NAME##*/}-${CHART_VERSION}"

  cat <<EOF
# ===== $CHART_NAME ==========================
chart:${CHART_NAME##*/}:lint:
  stage: test
  extends: [.lint:chart]
  variables:
  	CHARTS_ROOT: '${CHARTS_ROOT:-charts}'
  environment:
    CHART_NAME: "${CHART_NAME##*/}"

chart:${CHART_NAME##*/}:release:
  stage: release
  extends: [.release:chart]
  variables:
  	CHARTS_ROOT: '${CHARTS_ROOT:-charts}'
  environment:
    CHART_NAME: "${CHART_NAME##*/}"

# ================================================

EOF

done
