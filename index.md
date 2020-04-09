## Learning objective

Data contains a wealth of information that can be used to solve certain types of problems. Traditional data analysis approaches, like a person manually inspecting the data or a specialized computer program that automates the human analysis, quickly reach their limits due to the amount of data to be analyzed or the complexity of the problem.

Machine learning, and deep learning, which is a specialized type of machine learning, uses algorithms – also known as ”models” - to identify patterns in the data. A trained model can be used to make predictions or decisions, and solve problems such as analyzing the content of text (spoken and written), images, audio, and video. For example, a model can be trained to identify objects in an image, sounds in a an audio or video file or summarize the the content in text form.

![Identifying objects in an image using deep learning](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/deep_learning_example.png)

The [Model Asset Exchange](https://developer.ibm.com/series/create-model-asset-exchange/) is a curated repository of ready-to-use state-of-the-art free and open source deep learning models, which can be deployed as microservice Docker images in local, hybrid, or cloud environments.

By completing this quick lab, you learn how to use the OpenShift web console or OpenShift Container Platform command-line interface to:

* Deploy a model-serving microservice using a public container image on Docker Hub
* Create a route that exposes the microservice to the public

For illustrative purposes you will deploy the Object Detector microservice and the Image Caption Generator microservice. 

## Prerequisites

To follow this lab, you must have:

* A web browser that is supported by the Skills Network Labs, such as the latest versions of Mozilla FireFox or Chrome.

## Estimated time

It should take you approximately 20 minutes to complete this lab. The lab modules are:

* [Deploy using the OpenShift Web Console](#deploy-using-the-openshift-web-console)
* [Deploy using the OpenShift Platform CLI](#deploy-using-the-cli)

## Lab setup

1. Connect to the [Skills Network Labs environment](https://labs.cognitiveclass.ai/tools/theiaopenshift/?md_instructions_url=https://raw.githubusercontent.com/IBM/max-model-prediction-os/master/index.md) using your web browser. If required, log in.

1. Open a new terminal window (**Terminal** > **New Terminal**).

   ![Skills Network Labs environment](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/snl_overview.png)

1. Clone the lab repository by running the following command in the terminal window.
   ```
   git clone https://github.com/IBM/max-model-prediction-os.git
   cd max-model-prediction-os
   ```

   The cloned repository contains sample images and utility scripts.

You are ready to start the lab.

---

### Deploy using the OpenShift web console

In the first module you deploy the [MAX-Object-Detector microservice](https://developer.ibm.com/exchanges/models/all/max-object-detector/) on Red Hat OpenShift using the OpenShift web console. This microservice identifies objects in pictures, enabling you to build applications that need to interpret the content of a picture. 

![Object Detector sample app teaser](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/od_sample_app.png)

If you are interested in learning more about the microservice you can find the source code in [https://github.com/IBM/MAX-Object-Detector](https://github.com/IBM/MAX-Object-Detector) and the demo web application source code in [https://github.com/IBM/MAX-Object-Detector-Web-App](https://github.com/IBM/MAX-Object-Detector-Web-App).

#### Open the OpenShift web console 

1. Click **OpenShift Console**. 

   ![Open OpenShift console](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/open_rhos_web_console.png)

   The console opens in a new browser tab and the _developer_ view is displayed. OpenShift organizes related resources in projects. In the lab environment you are using a project named `sn-labs-...` that was automatically created for you.

   ![Red Hat OpenShift web console default view](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/rhos_web_console_default_view.png)

   You are ready to deploy the Object Detector microservice.

#### Deploy the microservice Docker image

You can deploy Docker images that are hosted in public or private registries. The MAX-Object-Detector Docker image `codait/max-object-detector` is hosted on [Docker Hub](https://hub.docker.com/r/codait/max-object-detector), which is a public registry.

1. Select **+Add** and choose **Container Image** as source.

   ![Select deployment source](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_add_something.png)

1. Select the **Image name from external registry** radio button.

1. Enter `codait/max-object-detector` as _Image Name_.

   ![Select Docker image](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_select_source_image.png)

1. Click on the magnifying glass next to the image name (or press Enter) to load the Docker image's metadata.

1. Review the deployment configuration for the Docker image.

   ```
   codait/max-object-detector Mar 31, 9:07 am, 476.4 MiB, 14 layers
   Image Stream max-object-detector:latest will track this image.
   This image will be deployed in Deployment Config max-object-detector.
   Port 5000/TCP will be load balanced by Service max-object-detector.
   Other containers can access this service through the hostname max-object-detector.
   ```

1. In the _General_ section the _Name_ field is pre-populated with the Docker image name. OpenShift uses this name to identify the resources being created when the application is deployed.

   ![Configure general settings](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_configure_general_settings.png)

   > If you append, modify, or delete a few characters, you'll notice how the name change is impacting the generated image stream name, the deployment configuration name, the service name, and the host name. (However, use the default **max-object-detector** in this lab!)

1. In the _Resources_ section make sure [**Deployment**](https://docs.openshift.com/container-platform/4.3/applications/deployments/what-deployments-are.html) is selected as resource type.

   ![Configure deployment type](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_configure_deployment_resource_type.png)

1. In the _Advanced Options_ section check **Create a route to the application** to expose the deployed application to the public. (If the option is not checked the application is only visible within the cluster.)

   ![Configure advanced options](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_configure_advanced_options.png)

   You can customize the route configuration by clicking the **Routing** link, for example by configuring whether to expose an unsecured route (the default) or a secured route. In this lab the default settings are fine.

   ![Configure route](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_configure_route.png)

1. Click the **Deployment** link to customize the deployment.

   ![Customize deployment options](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_configure_deployment.png)

   You can customize the behavior of the deployed microservice by setting environment variables. For example, you can enable [Cross-Origin Resource Sharing](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) support by setting the `CORS_ENABLE` variable in the deployment configuration to `true`. If CORS is enabled (which it is not by default) client applications that run in a web browser can call the microservice endpoints.

1. Click the **Scaling** link to configure how many copies of the deployed microservice you want to run. In this lab the default setting of 1 is sufficient because you are the only user who will utilize this service.

   ![Configure scaling](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_configure_scaling.png)

1. Click the **Resource Limit** link to configure the minimum and maximum amount of CPU and RAM the deployed microservice can utilize. Since the object detector microservice requires a minimum of 2 GB of RAM, configure the appropriate setting. 

   ![Configure resource limits](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_configure_resource_limits.png)

1. Click **Create** to deploy the microservice. The deployment toplogy view is displayed.

   ![View deployment topology](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_view_deployment_topology.png)

1. Click the **max-object-detector** label (marked with a dashed arrow in the screen capture) to open the deployment configuration panel.

   ![View deployment](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_view_deployment.png)

1. Select the **Resources** tab, which provides you with access to the log files and a link to the public route. 

   ![View deployment resources](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/ui_view_deployment_resources.png)

1. Open the displayed route URL to access the microservice's OpenAPI specification, which documents the endpoints applications and services can call to utilize the microservice.

   ![Review OpenAPI specification](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/view_od_openapi_spec.png)

1. Expand the **model** twistie to reveal the microservice endpoints. The Object Detector exposes three endpoints:
   - the `GET /model/metadata` endpoint, which provides information about the microservice
   - the `GET /model/labels` endpoint, which identifies the kinds of objects the microservice can detect in an image
   - the `POST /model/predict` endpoint, which detects objects in an image that is included in the payload when the endpoint is invoked 

   ![Review object detector endpoints](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/view_od_endpoints.png)

   You can try the endpoints by clicking on the name.

1. Click `GET /model/labels`, **Try it out**, and **Execute** to retrieve the list of objects that the microservice can detect in an image.

   ![Invoke the labels endpoint](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/view_od_labels_endpoint.png)

   The response should look as follows and includes how many types of objects can be detected and what they are.

   ![View labels endpoint response](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/view_od_labels_endpoint_response.png)

   The Object Detector microservice includes a small embedded demo application that illustrates how a web application can consume the `/model/predict` endpoint. 

1. Open the embedded sample application by appending `/app` to the public route of your deployed microservice, e.g. `http://max-object-detector-sn-labs-.../app`.

1. Test the microservice by selecting an image of your choice and changing the probability threshold. By lowering the threshold you can see objects that the Object Detector deep learning model is less certain about.

   ![Test embedded sample application](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/view_od_sample_app.png)

This completes the first module. In the next module you will deploy another model-serving microservice using the OpenShift Container Platform CLI.

---

### Deploy using the CLI

In this second module you deploy the [image caption generator deep learning microservice](https://developer.ibm.com/exchanges/models/all/max-image-caption-generator/) on Red Hat OpenShift using the OpenShift Container Platform CLI.

This microservice analyzes the content of an image and generates a one sentence description, which is useful if an application or service needs to automatically annotate user-provided content.

![Image Caption Generator sample app teaser](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/img_caption_sample_app.png)

If you are interested in learning more about the microservice you can find the source code in [https://github.com/IBM/MAX-Image-Caption-Generator](https://github.com/IBM/MAX-Image-Caption-Generator) and the demo web application source code in [https://github.com/IBM/MAX-Image-Caption-Generator-Web-App](https://github.com/IBM/MAX-Image-Caption-Generator-Web-App).

#### Setup

1. Open a new terminal window (**Terminal** > **New Terminal**).

   The OpenShift Container Platform CLI `oc` is pre-installed and pre-configured in the Skills Network Labs _Theia - Cloud IDE (With OpenShift)_ environment. 

   ![Skills Network Labs view](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/skills_network_labs_terminal_view.png)

1. Verify that you can access the CLI in your terminal.
 
   ```
   oc version
   ```

   If the client is properly configured the output is similar to this:

   ```
    client Version: 4.5.0-202002280431-79259a8
    Kubernetes Version: v1.16.2
   ```

1. As you learned in the first module, OpenShift uses projects to organize related resources. Display the current project.

   ```
   oc projects
   ```

   Your current project should be "sn-labs-...".


#### Deploy the image caption generator microservice Docker image

You can deploy Docker images that are hosted in public registries, such as Docker Hub or private registries. 

1. Verify that OpenShift can locate the public [`codait/max-image-caption-generator` Docker image on Docker Hub](https://hub.docker.com/r/codait/max-image-caption-generator).

   ```
   oc new-app --search codait/max-image-caption-generator
   ```

   The output should indicate that the Docker image was found in the public Docker Hub registry:

   ```
    Docker images (oc new-app --docker-image=<docker-image> [--code=<source>])
    -----
    codait/max-image-caption-generator
    Registry: Docker Hub
    Tags:     latest
   ```   

1. Deploy the Docker image on OpenShift.

   ```
   oc new-app codait/max-image-caption-generator
   ```

   Review the output and note that the image name `max-image-caption-generator` is used by default to name the generated resources, such as the image stream, the deployment configuration, the service, and the host.

   ```
   --> Found container image ... (... days old) from Docker Hub for "codait/max-image-caption-generator"

    * An image stream tag will be created as "max-image-caption-generator:latest" that will track this image
    * This image will be deployed in deployment config "max-image-caption-generator"
    * Port 5000/tcp will be load balanced by service "max-image-caption-generator"
      * Other containers can access this service through the hostname "max-image-caption-generator"
    * WARNING: Image "codait/max-image-caption-generator" runs as the 'root' user which may not be permitted by your cluster administrator

   --> Creating resources ...
    imagestream.image.openshift.io "max-image-caption-generator" created
    deploymentconfig.apps.openshift.io "max-image-caption-generator" created
    service "max-image-caption-generator" created
   --> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose svc/max-image-caption-generator' 
    Run 'oc status' to view your app.
   ```

   > You can change the default by supplying the `--name <my-custom-name>` parameter when you deploy the image.

1. You can customize the behavior of most model-serving microservices by setting environment variables. For example, you can enable [Cross-Origin Resource Sharing](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) support by setting the `CORS_ENABLE` variable in the deployment configuration to `true`:

   ```
   oc set env deploymentconfig max-image-caption-generator CORS_ENABLE=true
   ```

   With CORS enabled applications running in a web browser can now take utilize the microservice.

1. Query the deployment status.

   ```
   oc status
   ```

   After deployment completed one microservice instance is running. Note though that it is only visible internally (at port 5000) to the cluster and cannot yet be accessed by applications running elsewhere as indicated in the response:

   ```
   In project sn-labs-... on server https://...
   ...

   svc/max-image-caption-generator - 172.21.73.113:5000
    dc/max-image-caption-generator deploys istag/max-image-caption-generator:latest 
     deployment #2 running for 39 seconds - 0/1 pods growing to 1
     deployment #1 deployed 2 minutes ago - 1 pod
   ```

   > You can manually scale out the deployment by increasing the target number of running pods (`oc scale --replicas=2 deploymentconfig max-image-caption-generator`) or [configure autoscaling](https://docs.openshift.com/container-platform/4.3/nodes/pods/nodes-pods-autoscaling.html).

   To expose the service to the public, you must create a route.

#### Create a route

When you [create a route](https://docs.openshift.com/container-platform/4.3/dev_guide/routes.html) in OpenShift, you have the option to expose an unsecured or a secured route. Because the model-serving miroservice communicates over HTTP, you can configure the router to expose an unsecured HTTP connection (which is what you'll do in this lab) or expose a secured HTTP connection, which the OpenShift router automatically terminates.

1. Create a route for the service.
   ```
   oc expose service max-image-caption-generator
   ```

1. Retrieve the microservice's public URL.

   ```
   oc get route max-image-caption-generator
   ```   

   Under the `HOST/PORT` column, the generated host name is displayed.

   ```
   NAME                          HOST/PORT                                                          ...     
   max-image-caption-generator   max-image-caption-generator-sn-labs-....sn-labs-user-sandbox-...   ...
   ```

   > If the displayed `HOST/PORT` reads `InvalidHost`, the generated host name is invalid. This commonly happens when the length exceeds the 63-character maximum. To resolve the issue, shorten the route name. For example, to shorten the route name for the `max-image-caption-generator` service, run `oc expose service max-image-caption-generator --name <shorter-route-name>` followed by `oc get route <shorter-route-name>` to retrieve the public URL.

   For this lab we've created a utility script that parses the command output and displays the URL in a user-friendly format.

1. Run `scripts/get_model_url.sh`, passing the deployed service's name `max-image-caption-generator` as parameter.

   ```
   ./scripts/get_model_url.sh max-image-caption-generator
   ```

   If the service is accessible on a public route the URL is displayed.

1. Open the route URL `http://max-image-caption-generator-sn-...` in your web browser and review the microservice's OpenAPI specification, which documents the public endpoints that applications and service can utilize.

   ![Review OpenAPI specification](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/review_imgcap_openapi_spec.png)

1. You can now try out the microservice and generate image captions for your own pictures or the provided [sample pictures](https://github.com/IBM/max-model-prediction-os/tree/master/samples):
   1. Expand the **model** twistie.
   1. Click **POST /model/predict**.
   1. Click **Try it out**.
   1. Choose an image.
   1. Click **Execute**.

   ![Test image caption generator predict endpoint](https://github.com/IBM/max-model-prediction-os/raw/master/doc/images/test_img_caption_predict_endpoint.png)

      The JSON response includes up to three captions that describe the picture.

      ```
      {
       "status": "ok",
       "predictions": [
         {
            "index": "0",
            "caption": "a man sitting on a bench with a dog .",
            "probability": 0.00033008711294778146
         },
         {
            "index": "1",
            "caption": "a teddy bear sitting on a bench in a park .",
            "probability": 0.00031648055802071807
         },
         {
            "index": "2",
            "caption": "a teddy bear sitting on a bench in a park",
            "probability": 0.00009952772020596103
         }
       ]
      }
      ```

1. In your terminal window test the deployed microservice by sending any picture from the `samples` directory to the service's `/model/predict` endpoint.

   1. Run `scripts/get_model_prediction_endpoint.sh` passing the service's name `max-image-caption-generator` as parameter to retrieve the microservice's prediction endpoint.

      ```
      ./scripts/get_model_prediction_endpoint.sh max-image-caption-generator 
      ```

   1. Use cURL to send a picture to the displayed endpoint.

      ```
      curl -F "image=@samples/surfing.jpg" -X POST http://max-image-.../model/predict
      ```

      The JSON response includes up to three captions that describe the image content.
      ```
      {
         "status": "ok", 
         "predictions": 
            [
               {
                  "index": "0", 
                  "caption": "a man riding a wave on top of a surfboard .", 
                  "probability": 0.03882596589006486
               }, 
               {
                  "index": "1", 
                  "caption": "a person riding a surf board on a wave", 
                  "probability": 0.017932651547323004
               }, 
               {
                  "index": "2", 
                  "caption": "a man riding a wave on a surfboard in the ocean .", 
                  "probability": 0.005662559139518499
               }
            ]
      }
      ```  

 Note: For some compute-intensive models, calls to the `/model/predict` endpoint might result in [HTTP error 504 (Gateway timeout)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/504) if you use the router's default configuration. To resolve the issue, increase the router's timeout value by running `oc annotate route <router-name> --overwrite haproxy.router.openshift.io/timeout=<number-of-seconds>s`.  

## Summary

In this lab, you learned how to use the OpenShift web console or OpenShift Container Platform CLI to:

* Deploy a model-serving microservice from a public container image on Docker Hub
* Create a route that exposes the microservice to the public

To learn more about the Model Asset Exchange or how to consume the deployed model-serving microservice in Node-RED or JavaScript, take a look at [Learning Path: An introduction to the Model Asset Exchange](https://developer.ibm.com/series/create-model-asset-exchange/) and these [pens](https://codepen.io/collection/DzdpJM/).

You might find the following resources useful if you'd like to learn more about Red Hat OpenShift:
* [Getting started with Red Hat OpenShift on IBM Cloud](https://cloud.ibm.com/docs/openshift?topic=openshift-getting-started)
* [OpenShift Learning Portal](https://learn.openshift.com)
* [OpenShift Container Platform CLI reference](https://docs.openshift.com/container-platform/4.3/cli_reference/openshift_cli/getting-started-cli.html)
