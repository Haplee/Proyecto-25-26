
import os
from playwright.sync_api import sync_playwright, expect

def verify_focus_state():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        # Get the absolute path to the HTML file
        file_path = os.path.abspath('docs/index.html')

        # Navigate to the local HTML file
        page.goto(f'file://{file_path}')

        # Press the "Tab" key to focus the first navigation link
        page.keyboard.press('Tab')
        page.keyboard.press('Tab') # Pressing tab twice to get to the first nav link

        # Wait for the link to be focused
        focused_link = page.locator('nav ul li a:focus')
        expect(focused_link).to_be_visible()

        # Take a screenshot of the navigation bar
        page.locator('nav').screenshot(path='/home/jules/verification/focus_state.png')

        browser.close()

if __name__ == "__main__":
    verify_focus_state()
