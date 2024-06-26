#!/usr/bin/env -S python3 -u

from pathlib import Path
import sys
from time import sleep

from selenium import webdriver
from selenium.common import exceptions as selenium_exceptions
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.service import Service
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.ui import WebDriverWait


def printe(
    *values: object,
    sep: str = " ",
    end: str = "\n",
    header: str = " [x]",
    flush: bool = False,
):
    print(header, *values, sep=sep, end=end, file=sys.stderr, flush=flush)


def printm(
    *values: object,
    sep: str = " ",
    end: str = "\n",
    header: str = " [*]",
    flush: bool = False,
):
    print(header, *values, sep=sep, end=end, file=sys.stderr, flush=flush)


def read_credentials(credentials_path: Path):
    with open(credentials_path, "r") as f:
        username = f.readline().strip()
        password = f.readline().strip()
    return username, password


def find_element_by_id(
    driver: webdriver.Firefox, elem_id: str, timeout: int = 5
):
    element = WebDriverWait(driver, timeout).until(
        expected_conditions.presence_of_all_elements_located((By.ID, elem_id))
    )
    return element


def main(credentials_path: Path, log_file: Path):
    username, password = read_credentials(credentials_path)

    options = Options()
    options.add_argument("-headless")
    service = Service(executable_path="@geckodriver@/bin/geckodriver", log_output=open(log_file, "a"))

    printm(f"creating web driver instance ...")
    driver = webdriver.Firefox(service=service, options=options)

    zjuwlan = "https://net.zju.edu.cn/srun_portal_pc?ac_id=3&theme=zju"  # net
    # zjuwlan = "https://10.50.200.245/srun_portal_pc?ac_id=3&theme=zju"  # net
    # zjuwlan = "https://10.50.200.3/srun_portal_pc?ac_id=3&theme=zju"  # net2

    printm(f"getting web page at '{zjuwlan}' ...")

    driver.get(zjuwlan)

    printm(f"Driver started on {zjuwlan}")

    try:
        find_element_by_id(driver, "logout-dm")
        printm("already logged in, exiting in 3 seconds ..")
    except selenium_exceptions.TimeoutException:
        username_box = driver.find_element(By.ID, "username")
        password_box = driver.find_element(By.ID, "password")
        remember_box = driver.find_element(By.ID, "remember")

        username_box.send_keys(username)
        printm("Filled username")
        password_box.send_keys(password)
        printm("Filled password")
        if not remember_box.is_selected():
            remember_box.click()
        else:
            printm("remember box is already selected, not clicking it again")
        printm("Checked remember box")

        submit_button = driver.find_element(By.ID, "login")
        printm("Found submit button")
        submit_button.send_keys(Keys.ENTER)
        printm("Form submitted")
    finally:
        # Quit driver, or the process hangs in the background
        # Wait 3 seconds
        sleep(3)
        driver.close()
        printm("Driver closed", header=" [v]")


if __name__ == "__main__":
    try:
        _, credentials_path, log_file = sys.argv
    except:
        print("usage: {} <credentials_path> <log_file>".format(sys.argv[0]), file=sys.stderr)
        exit(1)

    credentials_path, log_file = map(Path, [credentials_path, log_file])
    exit(main(credentials_path, log_file))

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Sep 26 2020
