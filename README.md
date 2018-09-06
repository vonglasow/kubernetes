# Kubernetes

## Requirements

* [hub](https://github.com/github/hub)
* [gcloud](https://cloud.google.com/sdk/install)
* [kubectl](https://cloud.google.com/sdk/gcloud/reference/components/install)
* [git-secret](http://git-secret.io)

## Usage

```sh
hub clone ma-residence/kubernetes
cd kubernetes
cp .env.dist .env
# change constants to use your docker hub credentials
make api-doc ENV=dev
```
