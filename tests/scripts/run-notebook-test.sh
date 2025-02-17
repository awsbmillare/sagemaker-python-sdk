#!/bin/bash
#
# Run a test against a SageMaker notebook
# Only runs within the SDK's CI/CD environment

set -euo pipefail

python setup.py sdist
aws s3 --region us-west-2 cp ./dist/sagemaker-*.tar.gz s3://sagemaker-python-sdk-pr/sagemaker.tar.gz
aws s3 cp s3://sagemaker-mead-cli/mead-nb-test.tar.gz mead-nb-test.tar.gz
tar -xzf mead-nb-test.tar.gz
git clone --depth 1 https://github.com/awslabs/amazon-sagemaker-examples.git
export JAVA_HOME=$(get-java-home)
echo "set JAVA_HOME=$JAVA_HOME"
export SAGEMAKER_ROLE_ARN=$(aws iam list-roles --output text --query "Roles[?RoleName == 'SageMakerRole'].Arn")
echo "set SAGEMAKER_ROLE_ARN=$SAGEMAKER_ROLE_ARN"
./runtime/bin/mead-run-nb-test \
--instance-type ml.c4.8xlarge \
--region us-west-2 \
--lifecycle-config-name install-python-sdk \
--notebook-instance-role-arn $SAGEMAKER_ROLE_ARN \
./amazon-sagemaker-examples/advanced_functionality/kmeans_bring_your_own_model/kmeans_bring_your_own_model.ipynb \
./amazon-sagemaker-examples/advanced_functionality/tensorflow_iris_byom/tensorflow_BYOM_iris.ipynb \
./amazon-sagemaker-examples/sagemaker-python-sdk/1P_kmeans_highlevel/kmeans_mnist.ipynb \
./amazon-sagemaker-examples/sagemaker-python-sdk/1P_kmeans_lowlevel/kmeans_mnist_lowlevel.ipynb \
./amazon-sagemaker-examples/sagemaker-python-sdk/managed_spot_training_mxnet/managed_spot_training_mxnet.ipynb \
./amazon-sagemaker-examples/sagemaker-python-sdk/mxnet_gluon_sentiment/mxnet_sentiment_analysis_with_gluon.ipynb \
./amazon-sagemaker-examples/sagemaker-python-sdk/mxnet_onnx_export/mxnet_onnx_export.ipynb \
./amazon-sagemaker-examples/sagemaker-python-sdk/scikit_learn_randomforest/Sklearn_on_SageMaker_end2end.ipynb \
./amazon-sagemaker-examples/sagemaker-python-sdk/tensorflow_moving_from_framework_mode_to_script_mode/tensorflow_moving_from_framework_mode_to_script_mode.ipynb \
./amazon-sagemaker-examples/sagemaker-python-sdk/tensorflow_script_mode_pipe_mode/tensorflow_script_mode_pipe_mode.ipynb \
./amazon-sagemaker-examples/sagemaker-python-sdk/tensorflow_script_mode_quickstart/tensorflow_script_mode_quickstart.ipynb \
./amazon-sagemaker-examples/sagemaker-python-sdk/tensorflow_serving_using_elastic_inference_with_your_own_model/tensorflow_serving_pretrained_model_elastic_inference.ipynb \
./amazon-sagemaker-examples/sagemaker-pipelines/tabular/abalone_build_train_deploy/sagemaker-pipelines-preprocess-train-evaluate-batch-transform.ipynb