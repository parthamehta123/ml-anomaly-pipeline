from prometheus_client import start_http_server,Gauge
import random,time

cpu_g=Gauge("node_cpu_usage","CPU Usage")
mem_g=Gauge("node_memory_usage","Memory Usage")
disk_g=Gauge("node_disk_io","Disk IO")

def run():
    while True:
        cpu=random.gauss(50,10); mem=random.gauss(60,15); disk=random.gauss(100,20)
        if random.random()<0.02: cpu,mem,disk=95,95,250
        cpu_g.set(cpu); mem_g.set(mem); disk_g.set(disk)
        time.sleep(5)

if __name__=="__main__":
    start_http_server(8000); run()
