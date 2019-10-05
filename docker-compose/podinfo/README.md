# podinfo

[![CircleCI](https://circleci.com/gh/stefanprodan/podinfo.svg?style=svg)](https://circleci.com/gh/stefanprodan/podinfo)
[![Docker Pulls](https://img.shields.io/docker/pulls/stefanprodan/podinfo)](https://hub.docker.com/r/stefanprodan/podinfo)

Podinfo is a tiny web application made with Go 
that showcases best practices of running microservices in Kubernetes.

Specifications:

* Health checks (readiness and liveness)
* Graceful shutdown on interrupt signals
* File watcher for secrets and configmaps
* Instrumented with Prometheus
* Tracing with Istio and Jaeger
* Structured logging with zap 
* 12-factor app with viper
* Fault injection (random errors and latency)
* Swagger docs
* Helm and Kustomize installers
* End-to-End testing with Kubernetes Kind and Helm

Web API:

* `GET /` prints runtime information
* `GET /version` prints podinfo version and git commit hash 
* `GET /metrics` return HTTP requests duration and Go runtime metrics
* `GET /healthz` used by Kubernetes liveness probe
* `GET /readyz` used by Kubernetes readiness probe
* `POST /readyz/enable` signals the Kubernetes LB that this instance is ready to receive traffic
* `POST /readyz/disable` signals the Kubernetes LB to stop sending requests to this instance
* `GET /status/{code}` returns the status code
* `GET /panic` crashes the process with exit code 255
* `POST /echo` forwards the call to the backend service and echos the posted content 
* `GET /env` returns the environment variables as a JSON array
* `GET /headers` returns a JSON with the request HTTP headers
* `GET /delay/{seconds}` waits for the specified period
* `POST /token` issues a JWT token valid for one minute `JWT=$(curl -sd 'anon' podinfo:9898/token | jq -r .token)`
* `GET /token/validate` validates the JWT token `curl -H "Authorization: Bearer $JWT" podinfo:9898/token/validate`
* `GET /configs` returns a JSON with configmaps and/or secrets mounted in the `config` volume
* `POST /store` writes the posted content to disk at /data/hash and returns the SHA1 hash of the content
* `GET /store/{hash}` returns the content of the file /data/hash if exists
* `GET /ws/echo` echos content via websockets `podcli ws ws://localhost:9898/ws/echo`
* `GET /chunked/{seconds}` uses `transfer-encoding` type `chunked` to give a partial response and then waits for the specified period
* `GET /swagger.json` returns the API Swagger docs, used for Linkerd service profiling and Gloo routes discovery

gRPC API:

* `/grpc.health.v1.Health/Check` health checking

Web UI:

![podinfo-ui](https://raw.githubusercontent.com/stefanprodan/podinfo/gh-pages/screens/podinfo-ui.png)

To access the Swagger UI open `<podinfo-host>/swagger/index.html` in a browser.

### Guides

* [Automated canary deployments with Flagger and Istio](https://medium.com/google-cloud/automated-canary-deployments-with-flagger-and-istio-ac747827f9d1)
* [Kubernetes autoscaling with Istio metrics](https://medium.com/google-cloud/kubernetes-autoscaling-with-istio-metrics-76442253a45a)
* [Managing Helm releases the GitOps way](https://medium.com/google-cloud/managing-helm-releases-the-gitops-way-207a6ac6ff0e)
* [Expose Kubernetes services over HTTPS with Ngrok](https://stefanprodan.com/2018/expose-kubernetes-services-over-http-with-ngrok/)

### Install

Helm:

```bash
helm repo add sp https://stefanprodan.github.io/podinfo

helm upgrade --install --wait frontend \
--namespace test \
--set replicaCount=2 \
--set backend=http://backend-podinfo:9898/echo \
sp/podinfo

helm test frontend --cleanup

helm upgrade --install --wait backend \
--namespace test \
--set hpa.enabled=true \
sp/podinfo
```

Kustomize:

```bash
kubectl apply -k github.com/stefanprodan/podinfo//kustomize
```

Docker:

```bash
docker run -dp 9898:9898 stefanprodan/podinfo
```