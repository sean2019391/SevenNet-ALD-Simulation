# Lab Management Notes

## 1. Safety Inspection

- Room 310, Building 102 is a **secured area**. The door must auto-close via its damper mechanism.
- If the door fails to close automatically, contact the facilities maintenance office.
- Note: Temperature differences may prevent automatic closing; further measures may not be available.

---

## 2. Travel Approval

When modifying a travel request, the reason field should describe **only the changed items**.

Example: If the change is adding personal vehicle use, write:
> "Personal vehicle use was not originally requested" or "No public transportation available at destination"

---

## 3. Workstation / Cluster Setup

### Register IP Address
1. Go to the university network registration portal
2. Log in
3. Navigate to **Remote Access**
4. Enter the MAC address of your workstation/cluster

### Check System Status (requires root)
```bash
ipmitool sdr    # Shows status and temperatures
```
> `nitemp` = Ethernet socket temperature

### Check Individual Node Temperature
```bash
rsh node01       # SSH into a specific node
ipmitool sdr     # Check that node's status
rsh <master>     # Return to master node
```

---

## 4. Add a User to ORCA Cluster

```bash
adduser <username>
passwd <username>
cd /var/yp/
make
```

---

## 5. Rebooting the ORCA Cluster

**Shutdown order:** Shut down each worker node first, then the master.

```bash
# On each node:
shutdown -h now
```

**Boot order:** Start the master first, then each worker node (reverse of shutdown).
