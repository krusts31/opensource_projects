# Instruction usded to setup pihole


## LISTS

```
https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/pro.plus.txt	
https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/ultimate.txt	
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts	
https://adaway.org/hosts.txt	
https://big.oisd.nl/	
https://raw.githubusercontent.com/d3ward/toolz/master/src/d3host.txt
```

## AUTO UPDATE 

```bash
sudo apt install unattended-upgrades

echo 'Unattended-Upgrade::Origins-Pattern {
//      Fix missing Rasbian sources.
        "origin=Debian,codename=${distro_codename},label=Debian";
        "origin=Debian,codename=${distro_codename},label=Debian-Security";
        "origin=Raspbian,codename=${distro_codename},label=Raspbian";
        "origin=Raspberry Pi Foundation,codename=${distro_codename},label=Raspberry Pi Foundation";
};' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-raspbian
```

## INSSTALL

[Follow this](https://docs.pi-hole.net/main/basic-install/)


## ROUTER STUFF

make sure to amm how to say make the DNS come form RP ONLY, mikroti uses dynamic DNS so those need to be disabled.


## HARDWARE

[RP MODULE](https://www.digikey.lv/en/products/detail/raspberry-pi/SC0020/18150025?s=N4IgTCBcDa4GwBYAcBaAygYQAxbFlAcgCIgC6AvkA&src=raspberrypi)
[SD CARD](https://www.digikey.lv/en/products/detail/raspberry-pi/SC1628/24627139)
