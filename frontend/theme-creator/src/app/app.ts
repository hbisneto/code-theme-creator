import { Component } from '@angular/core';
import { ThemeForm } from './theme-form/theme-form';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [ThemeForm], // Remove RouterOutlet se não for usar roteamento
  templateUrl: './app.html',
  styleUrls: ['./app.css']
})
export class App {
  protected title = 'theme-creator';
}