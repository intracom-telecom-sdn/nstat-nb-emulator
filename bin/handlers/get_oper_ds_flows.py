#!/usr/bin/env python
"""Get the number of started switches
Command line handler to get the number of started switches
from the distributed topologies
"""

import util.multinet_requests as m_util


def get_oper_ds_flows_main():
    """Main
    Send a POST request to the master 'get_switches' endpoint,
    validate the response code and print the responses

    Usage:
      bin/handler/get_switches --json-config <path-to-json-conf>

    Example:
      bin/handler/get_switches --json-config config/runtime_config.json

    Command Line Arguments:
      json-config (str): Path to the JSON configuration file to be used
    """

    odl_inventory = \
            emulators.nb_generator.flow_utils.FlowExplorer(self.controller.ip,
                                                           self.controller.restconf_port,
                                                           'operational',
                                                           (self.controller.restconf_user,
                                                           self.controller.restconf_pass))
        odl_inventory.get_inventory_flows_stats()
        logging.debug('Found {0} flows at inventory'.
                      format(odl_inventory.found_flows))
        return odl_inventory.found_flows


if __name__ == '__main__':
    get_oper_ds_flows_main()
