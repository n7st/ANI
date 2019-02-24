# ANI

Work in progress. Send stats from your network to InfluxDB.

## Supported sources

* Huawei HG612 modems

## Supported destinations

* InfluxDB

## Usage

Copy `config.yml.example` to `config.yml` and edit it with your own
configuration.

Run the poller:

```
perl bin/ani
```

## License

MIT. See [LICENSE.txt](/LICENSE.txt).

## Further reading

* [Kitz - Huawei Modem](https://kitz.co.uk/routers/openreach-modems.htm#Huawei_modem)
* [AAISP - Router - EchoLife HG612](https://support.aa.net.uk/Router_-_EchoLife_HG612)

