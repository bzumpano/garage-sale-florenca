import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.initializeCarousels()
  }

  disconnect() {
    // Clean up if needed
  }

  initializeCarousels() {
    // Initialize all carousels on the page using Flowbite's global API
    const carouselElements = document.querySelectorAll('[data-carousel="slide"]')
    
    carouselElements.forEach((carouselElement) => {
      // Check if carousel is already initialized
      if (!carouselElement.hasAttribute('data-carousel-initialized')) {
        carouselElement.setAttribute('data-carousel-initialized', 'true')
        
        // Let Flowbite handle the initialization automatically
        // The data attributes will trigger Flowbite's auto-initialization
        console.log('Carousel initialized:', carouselElement.id)
      }
    })
  }
} 