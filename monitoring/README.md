# Monitoring Multiprover AVS

## Setup

1. Change your shell current working directory to this folder.

2. Now, run the following command to start the monitoring stack:
```bash
docker compose up -d
```

3. If you are running the multiprover holesky node, run the following command to connect your multiprover node network to the monitoring network:
```bash
docker network connect multiprover-avs-network prometheus
```

4. If you are running the multiprover mainnet node, run the following command to connect your multiprover mainnet node network to the monitoring network:
```bash
docker network connect multiprover-avs-mainnet-network prometheus
```

5. Done! Now Prometheus should be scraping the metrics from the multiprover avs node(s) that you have setup. Give it a few minutes and you should also be able to see some metrics in your Grafana dashboards.


## Dashboards
By default, Multiprover AVS provides a set of Grafana dashboards [here](./dashboards/), which are automatically imported if you followed the steps above. These can be used to quickly see the health of your Multiprover Node(s) and whether there are any problems.
