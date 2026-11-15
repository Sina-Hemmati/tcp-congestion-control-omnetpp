package tcpstudy;

import inet.node.inet.StandardHost;
import inet.node.inet.Router;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;

channel BottleneckChannel extends ned.DatarateChannel
{
    delay = default(50ms);
    datarate = default(5Mbps);
}

network SimpleTcpNetwork
{
    parameters:
        double rateBottleneck @unit(bps) = default(5Mbps);
        double delayBottleneck @unit(s)  = default(50ms);
    submodules:
        configurator: Ipv4NetworkConfigurator {
            parameters:
                @display("p=300,50");
        }
        client: StandardHost {
            parameters:
                @display("p=100,200");
        }
        router: Router {
            parameters:
                @display("p=300,200");
        }
        server: StandardHost {
            parameters:
                @display("p=500,200");
        }
    connections allowunconnected:
        // Fast access link client <-> router
        client.pppg++ <--> ned.DatarateChannel { datarate = 100Mbps; delay = 2ms; } <--> router.pppg++;

        // Bottleneck link router <-> server
        router.pppg++ <--> BottleneckChannel { datarate = parent.rateBottleneck; delay = parent.delayBottleneck; } <--> server.pppg++;
}
