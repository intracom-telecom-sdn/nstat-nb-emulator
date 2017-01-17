#! /usr/bin/env python3.4

"""This handler returns the number of installed flows of a topology, connected
to the controller. This information using FlowExplorer object to explore
controller inventory flows, using the NB REST interface.
"""

import sys

def get_oper_flows(self):
    """Query number of flows registered in ODL operational DS
    :returns: number of flows found, 0 if none exists and -1 in case of error.
    :rtype: int
    """
    ip = sys.argv[1]
    restconf_port = sys.argv[2]
    restconf_user = sys.argv[3]
    restconf_pass = sys.argv[4]

    odl_inventory = \
        emulators.nb_generator.flow_utils.FlowExplorer(ip,
                                                       restconf_port,
                                                       'operational',
                                                       (restconf_user,
                                                        restconf_pass))
    odl_inventory.get_inventory_flows_stats()
    logging.debug('Found {0} flows at inventory'.
                  format(odl_inventory.found_flows))
    print(odl_inventory.found_flows)

if __name__ == '__main__':
    get_oper_flows()