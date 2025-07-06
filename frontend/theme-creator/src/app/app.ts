import { Component } from '@angular/core';
import { ThemeForm } from './theme-form/theme-form';
import { Navigationbar } from './navigationbar/navigationbar';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    ThemeForm,
    Navigationbar
  ], // Remove RouterOutlet se não for usar roteamento
  templateUrl: './app.html',
  styleUrls: ['./app.css']
})
export class App {
  protected title = 'theme-creator';
}