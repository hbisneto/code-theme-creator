import { provideHttpClient } from '@angular/common/http';
import { provideRouter } from '@angular/router';
import { bootstrapApplication } from '@angular/platform-browser';
import { importProvidersFrom } from '@angular/core';
// import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { App } from './app/app';

bootstrapApplication(App, {
  providers: [
    provideRouter([]),
    provideHttpClient(),
    // importProvidersFrom(BrowserAnimationsModule)
  ]
}).catch(err => console.error(err));