#!/usr/bin/env bash
echo "🛠️  Setting up the environment..."
if [ -z "${PACKAGE_REGISTRY_PASSWORD}" ]; then
  echo "🙏 Please set the PACKAGE_REGISTRY_PASSWORD environment variable with the given value."
  exit 1
fi

echo "✨ Retrieving kubeconfig..."
mkdir -p "${HOME}/.kube"
curl --user "devoxx-france-2025:${PACKAGE_REGISTRY_PASSWORD}" "https://gitlab.com/api/v4/projects/61919198/packages/generic/polytech-2025/20251219/kubeconfig.yml" --output "${HOME}/.kube/config"
if [ $? -ne 0 ]; then
  echo "❌ Error when retrieving kubeconfig, is the password correct ?"
  exit 1
fi
chmod 600 "${HOME}/.kube/config"

echo "🚀 Setup finished. You can now select your kube context to interact with the cluster with : kubectx student-X"
