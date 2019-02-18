# HG612 Stats

Work in progress. Send stats from a Huawei HG612 modem to an InfluxDB database.

## Usage

```
perl hg612-stats.pl \
    -u admin        \                          # HG612 username
    -p admin        \                          # HG612 password
    -a 192.168.1.1  \                          # HG612 address
    -i http://192.168.1.2:8086/write?db=hg612; # InfluxDB database
```

## License

MIT. See [LICENSE](/LICENSE).

## Further reading

* [Kitz - Huawei Modem](https://kitz.co.uk/routers/openreach-modems.htm#Huawei_modem)
* [AAISP - Router - EchoLife HG612](https://support.aa.net.uk/Router_-_EchoLife_HG612)

