import { Controller } from "@hotwired/stimulus"
import { Carousel } from 'flowbite'

export default class extends Controller {
  connect() {
    this.initializeCarousels()
  }

  disconnect() {
    // Clean up if needed
  }

  initializeCarousels() {
    // Initialize all carousels on the page
    const carouselElements = document.querySelectorAll('[data-carousel="slide"]')
    
    carouselElements.forEach((carouselElement) => {
      // Check if carousel is already initialized
      if (!carouselElement.hasAttribute('data-carousel-initialized')) {
        carouselElement.setAttribute('data-carousel-initialized', 'true')
        
        // Get carousel items
        const items = carouselElement.querySelectorAll('[data-carousel-item]')
        const carouselItems = Array.from(items).map((item, index) => ({
          position: index,
          el: item
        }))

        // Get indicators if they exist
        const indicators = carouselElement.querySelectorAll('[data-carousel-slide-to]')
        const carouselIndicators = Array.from(indicators).map((indicator, index) => ({
          position: index,
          el: indicator
        }))

        // Get controls
        const prevButton = carouselElement.querySelector('[data-carousel-prev]')
        const nextButton = carouselElement.querySelector('[data-carousel-next]')

        // Create carousel options
        const options = {
          defaultPosition: 0,
          interval: 5000, // 5 seconds
          indicators: {
            activeClasses: 'bg-white dark:bg-gray-800',
            inactiveClasses: 'bg-white/50 dark:bg-gray-800/50 hover:bg-white dark:hover:bg-gray-800',
            items: carouselIndicators
          },
          onNext: () => {
            console.log('Next slide')
          },
          onPrev: () => {
            console.log('Previous slide')
          },
          onChange: () => {
            console.log('Slide changed')
          }
        }

        // Initialize the carousel
        const carousel = new Carousel(carouselElement, carouselItems, options)

        // Add event listeners for controls if they exist
        if (prevButton) {
          prevButton.addEventListener('click', () => {
            carousel.prev()
          })
        }

        if (nextButton) {
          nextButton.addEventListener('click', () => {
            carousel.next()
          })
        }

        // Store carousel instance for potential cleanup
        carouselElement.carouselInstance = carousel
      }
    })
  }
} 