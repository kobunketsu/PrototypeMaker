import scrapy

from scrapy.spidermiddlewares.httperror import HttpError
from twisted.internet.error import DNSLookupError
from twisted.internet.error import TimeoutError, TCPTimedOutError

from scrapy.spiders import Spider
from scrapy.selector import Selector

from steamspy.items import SteamspyItem

class TagSpider(Spider):
    name = "steamspy"
    allowed_domains = ["https://steamdb.info"]
    start_urls = [
        "https://steamdb.info/stats/gameratings/",
    ]
        
    def parse(self, response):
        self.logger.info("parse game %s", response.url)
        for href in response.xpath("//a[contains(@href, '/app/')]").css("a::attr('href')"):
            url = response.urljoin(href.extract())

            allItems = []
            items = yield scrapy.Request(url, 
                callback=self.parse_game,
                errback=self.errback_httpbin,
                dont_filter=True)
            allItems.append(items)
            
        yield allItems

        
    def parse_game(self, response):
        self.logger.info("Visited %s", response.url) 
        """
            scrap keword from site
        """
        desc = response.xpath("//p[@class='header-description']/text()").extract()[0]

        name = response.xpath("//td[@itemprop='name']/text()").extract()[0]

        image_url = response.xpath("//img[@class='app-logo']").css("img::attr('src')").extract()[0]

        item = SteamspyItem()
        item['name'] = name
        item['tags'] = []
        item['desc'] = desc
        item['image_urls'] = []
        item['image_urls'].append(image_url)

        for sel in response.xpath("//a[contains(@href, '/tags/?tagid=')]/text()").extract():
            item['tags'].append(sel)
            # print keyword
            # items.append(item)

        return item
        
    def errback_httpbin(self, failure):
        # log all failures
        self.logger.error(repr(failure))

        # in case you want to do something special for some errors,
        # you may need the failure's type:

        if failure.check(HttpError):
            # these exceptions come from HttpError spider middleware
            # you can get the non-200 response
            response = failure.value.response
            self.logger.error('HttpError on %s', response.url)

        elif failure.check(DNSLookupError):
            # this is the original request
            request = failure.request
            self.logger.error('DNSLookupError on %s', request.url)

        elif failure.check(TimeoutError, TCPTimedOutError):
            request = failure.request
            self.logger.error('TimeoutError on %s', request.url)               